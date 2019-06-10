package com.jiewen.jwp.base.query.handler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import com.jiewen.jwp.base.query.domain.Query;
import com.jiewen.jwp.base.query.domain.QueryContext;
import com.jiewen.jwp.common.ConfigurationUtil;


@Component
public class QueryDefinition {

    public static final String DEFAULT_CONFIG_LOCATION = "query/*.xml";

    static final Logger log = LoggerFactory.getLogger(QueryDefinition.class);

    private static QueryDefinition instance = new QueryDefinition();

    private final Map<String, Query> querys = new HashMap<>();

    private final Map<Resource, Long> cachedFiles = new HashMap<>();

    private int cachedFilesCount;

    @SuppressWarnings("rawtypes")
    private QueryDefinition() {

        cachedFilesCount = 0;
        Resource[] resources = ConfigurationUtil.getAllResources(DEFAULT_CONFIG_LOCATION);
        if (resources != null) {
            for (int i = 0; i < resources.length; i++) {
                Resource resource = resources[i];
                if (log.isInfoEnabled()) {
                    log.info("Loading query from {{}}", resource.toString());
                }
                try {
                    QueryContext queryContext = (QueryContext) ConfigurationUtil
                            .parseXMLObject(QueryContext.class, resource);
                    List list = queryContext.getQueries();
                    Iterator it = list.iterator();
                    do {
                        if (!it.hasNext()) {
                            break;
                        }
                        Query query = (Query) it.next();
                        Query previous = querys.put(query.getId(), query);
                        if (previous != null && log.isErrorEnabled()) {
                            log.error("Duplicated Query register! id[{" + query.getId() + "}]," + "in file {"
                                    + resource.toString() + "}");
                        }
                    } while (true);
                    if (resource.getURL().getProtocol().equals("file")) {
                        cachedFiles.put(resource, Long.valueOf(resource.getFile().lastModified()));
                    }
                } catch (IOException e) {
                    log.error("Could not load query from {{} }, reason:{}", resource.toString(), e);
                } catch (RuntimeException e) {
                    log.error("Fail to digester query from {{}}, reason:{}", resource, e);
                }
            }

            cachedFilesCount = cachedFiles.size();
            log.debug("cached query files: {}", cachedFilesCount);
        }
    }

    /**
     * 获取ID.
     * 
     * @param queryId
     *            参数
     * @return 返回
     */
    public static Query getQueryById(String queryId) {
        instance.update();
        return instance.querys.get(queryId);
    }

    @SuppressWarnings("rawtypes")
    public static Map getQuerys() {

        return instance.querys;
    }

    public static QueryDefinition getInstance() {

        return instance;
    }

    @SuppressWarnings("rawtypes")
    public void update() {

        if (cachedFilesCount > 0) {
            for (Iterator i = cachedFiles.keySet().iterator(); i.hasNext();) {
                Resource resource = (Resource) i.next();
                synchronized (cachedFiles) {
                    try {
                        if (resource.getFile().lastModified() > cachedFiles.get(resource).longValue()) {
                            QueryContext queryContext = (QueryContext) ConfigurationUtil
                                    .parseXMLObject(QueryContext.class, resource);
                            List list = queryContext.getQueries();
                            Query query;
                            for (Iterator it = list.iterator(); it.hasNext(); log.debug("Update Query id["
                                    + query.getId() + "], in {" + resource.toString() + "}")) {
                                query = (Query) it.next();
                                instance.querys.put(query.getId(), query);
                            }
                            cachedFiles.put(resource, Long.valueOf(resource.getFile().lastModified()));
                        }
                    } catch (IOException e) {
                        log.error("Could not load query from {" + resource.toString() + "}, reason:", e);
                    } catch (RuntimeException e) {
                        log.error("Fail to digester query from {" + resource.toString() + "}, reason:", e);
                    }
                }
            }

        }
    }

}
