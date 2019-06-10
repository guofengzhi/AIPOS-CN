package com.jiewen.ota;

import java.lang.management.ClassLoadingMXBean;
import java.lang.management.CompilationMXBean;
import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryManagerMXBean;
import java.lang.management.MemoryPoolMXBean;
import java.lang.management.MemoryUsage;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.RuntimeMXBean;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;


public class JvmInfo {
    private static final Logger logger = Logger.getLogger(JvmInfo.class);

    static final long MB = 1024 * 1024;

    public static void main(String[] args) {
        logger.info(System.getProperty("user.home"));

        // 打印系统信息
        logger.info("===========打印系统信息==========");
        printOperatingSystemInfo();
        // 打印编译信息
        logger.info("===========打印编译信息==========");
        printCompilationInfo();
        // 打印类加载信息
        logger.info("===========打印类加载信息==========");
        printClassLoadingInfo();
        // 打印运行时信息
        logger.info("===========打印运行时信息==========");
        printRuntimeInfo();
        // 打印内存管理器信息
        logger.info("===========打印内存管理器信息==========");
        printMemoryManagerInfo();
        // 打印垃圾回收信息
        logger.info("===========打印垃圾回收信息==========");
        printGarbageCollectorInfo();
        // 打印vm内存
        logger.info("===========打印vm内存信息==========");
        printMemoryInfo();
        // 打印vm各内存区信息
        logger.info("===========打印vm各内存区信息==========");
        printMemoryPoolInfo();
        // 打印线程信息
        logger.info("===========打印线程==========");
        printThreadInfo();

    }

    private static void printOperatingSystemInfo() {
        OperatingSystemMXBean system = ManagementFactory.getOperatingSystemMXBean();
        // 相当于System.getProperty("os.name").
        logger.info("系统名称:" + system.getName());
        // 相当于System.getProperty("os.version").
        logger.info("系统版本:" + system.getVersion());
        // 相当于System.getProperty("os.arch").
        logger.info("操作系统的架构:" + system.getArch());
        // 相当于 Runtime.availableProcessors()
        logger.info("可用的内核数:" + system.getAvailableProcessors());

        if (isSunOsMBean(system)) {
            long totalPhysicalMemory = getLongFromOperatingSystem(system,
                    "getTotalPhysicalMemorySize");
            long freePhysicalMemory = getLongFromOperatingSystem(system,
                    "getFreePhysicalMemorySize");
            long usedPhysicalMemorySize = totalPhysicalMemory - freePhysicalMemory;

            logger.info("总物理内存(M):" + totalPhysicalMemory / MB);
            logger.info("已用物理内存(M):" + usedPhysicalMemorySize / MB);
            logger.info("剩余物理内存(M):" + freePhysicalMemory / MB);

            long totalSwapSpaceSize = getLongFromOperatingSystem(system, "getTotalSwapSpaceSize");
            long freeSwapSpaceSize = getLongFromOperatingSystem(system, "getFreeSwapSpaceSize");
            long usedSwapSpaceSize = totalSwapSpaceSize - freeSwapSpaceSize;

            logger.info("总交换空间(M):" + totalSwapSpaceSize / MB);
            logger.info("已用交换空间(M):" + usedSwapSpaceSize / MB);
            logger.info("剩余交换空间(M):" + freeSwapSpaceSize / MB);
        }
    }

    private static long getLongFromOperatingSystem(OperatingSystemMXBean operatingSystem,
            String methodName) {
        try {
            final Method method = operatingSystem.getClass().getMethod(methodName,
                    (Class<?>[]) null);
            method.setAccessible(true);
            return (Long) method.invoke(operatingSystem, (Object[]) null);
        } catch (final InvocationTargetException e) {
            if (e.getCause() instanceof Error) {
                throw (Error) e.getCause();
            } else if (e.getCause() instanceof RuntimeException) {
                throw (RuntimeException) e.getCause();
            }
            throw new IllegalStateException(e.getCause());
        } catch (final NoSuchMethodException e) {
            throw new IllegalArgumentException(e);
        } catch (final IllegalAccessException e) {
            throw new IllegalStateException(e);
        }
    }

    private static void printCompilationInfo() {
        CompilationMXBean compilation = ManagementFactory.getCompilationMXBean();
        logger.info("JIT编译器名称：" + compilation.getName());
        // 判断jvm是否支持编译时间的监控
        if (compilation.isCompilationTimeMonitoringSupported()) {
            logger.info("总编译时间：" + compilation.getTotalCompilationTime() + "秒");
        }
    }

    private static void printClassLoadingInfo() {
        ClassLoadingMXBean classLoad = ManagementFactory.getClassLoadingMXBean();
        logger.info("已加载类总数：" + classLoad.getTotalLoadedClassCount());
        logger.info("已加载当前类：" + classLoad.getLoadedClassCount());
        logger.info("已卸载类总数：" + classLoad.getUnloadedClassCount());

    }

    private static void printRuntimeInfo() {
        RuntimeMXBean runtime = ManagementFactory.getRuntimeMXBean();
        logger.info("进程PID=" + runtime.getName().split("@")[0]);
        logger.info("jvm规范名称:" + runtime.getSpecName());
        logger.info("jvm规范运营商:" + runtime.getSpecVendor());
        logger.info("jvm规范版本:" + runtime.getSpecVersion());
        // 返回虚拟机在毫秒内的开始时间。该方法返回了虚拟机启动时的近似时间
        logger.info("jvm启动时间（毫秒）:" + runtime.getStartTime());
        // 相当于System.getProperties
        logger.info("获取System.properties:" + runtime.getSystemProperties());
        logger.info("jvm正常运行时间（毫秒）:" + runtime.getUptime());
        // 相当于System.getProperty("java.vm.name").
        logger.info("jvm名称:" + runtime.getVmName());
        // 相当于System.getProperty("java.vm.vendor").
        logger.info("jvm运营商:" + runtime.getVmVendor());
        // 相当于System.getProperty("java.vm.version").
        logger.info("jvm实现版本:" + runtime.getVmVersion());
        List<String> args = runtime.getInputArguments();
        if (args != null && !args.isEmpty()) {
            logger.info("vm参数:");
            for (String arg : args) {
                logger.info(arg);
            }
        }
        logger.info("类路径:" + runtime.getClassPath());
        logger.info("引导类路径:" + runtime.getBootClassPath());
        logger.info("库路径:" + runtime.getLibraryPath());
    }

    private static void printMemoryManagerInfo() {
        List<MemoryManagerMXBean> managers = ManagementFactory.getMemoryManagerMXBeans();
        if (managers != null && !managers.isEmpty()) {
            for (MemoryManagerMXBean manager : managers) {
                logger.info("vm内存管理器：名称=" + manager.getName() + ",管理的内存区="
                        + Arrays.deepToString(manager.getMemoryPoolNames()) + ",ObjectName="
                        + manager.getObjectName());
            }
        }
    }

    private static void printGarbageCollectorInfo() {
        List<GarbageCollectorMXBean> garbages = ManagementFactory.getGarbageCollectorMXBeans();
        for (GarbageCollectorMXBean garbage : garbages) {
            logger.info("垃圾收集器：名称=" + garbage.getName() + ",收集=" + garbage.getCollectionCount()
                    + ",总花费时间=" + garbage.getCollectionTime() + ",内存区名称="
                    + Arrays.deepToString(garbage.getMemoryPoolNames()));
        }
    }

    private static void printMemoryInfo() {
        MemoryMXBean memory = ManagementFactory.getMemoryMXBean();
        MemoryUsage headMemory = memory.getHeapMemoryUsage();
        logger.info("head堆:");
        logger.info("\t初始(M):" + headMemory.getInit() / MB);
        logger.info("\t最大(上限)(M):" + headMemory.getMax() / MB);
        logger.info("\t当前(已使用)(M):" + headMemory.getUsed() / MB);
        logger.info("\t提交的内存(已申请)(M):" + headMemory.getCommitted() / MB);
        logger.info("\t使用率:" + headMemory.getUsed() * 100 / headMemory.getCommitted() + "%");

        logger.info("non-head非堆:");
        MemoryUsage nonheadMemory = memory.getNonHeapMemoryUsage();
        logger.info("\t初始(M):" + nonheadMemory.getInit() / MB);
        logger.info("\t最大(上限)(M):" + nonheadMemory.getMax() / MB);
        logger.info("\t当前(已使用)(M):" + nonheadMemory.getUsed() / MB);
        logger.info("\t提交的内存(已申请)(M):" + nonheadMemory.getCommitted() / MB);
        logger.info("\t使用率:" + nonheadMemory.getUsed() * 100 / nonheadMemory.getCommitted() + "%");
    }

    private static void printMemoryPoolInfo() {
        List<MemoryPoolMXBean> pools = ManagementFactory.getMemoryPoolMXBeans();
        if (pools != null && !pools.isEmpty()) {
            for (MemoryPoolMXBean pool : pools) {
                // 只打印一些各个内存区都有的属性，一些区的特殊属性，可看文档或百度
                // 最大值，初始值，如果没有定义的话，返回-1，所以真正使用时，要注意
                logger.info("vm内存区:\n\t名称=" + pool.getName() + "\n\t所属内存管理者="
                        + Arrays.deepToString(pool.getMemoryManagerNames()) + "\n\t ObjectName="
                        + pool.getObjectName() + "\n\t初始大小(M)=" + pool.getUsage().getInit() / MB
                        + "\n\t最大(上限)(M)=" + pool.getUsage().getMax() / MB + "\n\t已用大小(M)="
                        + pool.getUsage().getUsed() / MB + "\n\t已提交(已申请)(M)="
                        + pool.getUsage().getCommitted() / MB + "\n\t使用率="
                        + (pool.getUsage().getUsed() * 100 / pool.getUsage().getCommitted()) + "%");

            }
        }
    }

    private static void printThreadInfo() {
        ThreadMXBean thread = ManagementFactory.getThreadMXBean();
        logger.info("ObjectName=" + thread.getObjectName());
        logger.info("仍活动的线程总数=" + thread.getThreadCount());
        logger.info("峰值=" + thread.getPeakThreadCount());
        logger.info("线程总数（被创建并执行过的线程总数）=" + thread.getTotalStartedThreadCount());
        logger.info("当初仍活动的守护线程（daemonThread）总数=" + thread.getDaemonThreadCount());

        // 检查是否有死锁的线程存在
        long[] deadlockedIds = thread.findDeadlockedThreads();
        if (deadlockedIds != null && deadlockedIds.length > 0) {
            ThreadInfo[] deadlockInfos = thread.getThreadInfo(deadlockedIds);
            logger.info("死锁线程信息:");
            logger.info("\t\t线程名称\t\t状态\t\t");
            for (ThreadInfo deadlockInfo : deadlockInfos) {
                logger.info("\t\t" + deadlockInfo.getThreadName() + "\t\t"
                        + deadlockInfo.getThreadState() + "\t\t" + deadlockInfo.getBlockedTime()
                        + "\t\t" + deadlockInfo.getWaitedTime() + "\t\t"
                        + deadlockInfo.getStackTrace().toString());
            }
        }
        long[] threadIds = thread.getAllThreadIds();
        if (threadIds != null && threadIds.length > 0) {
            ThreadInfo[] threadInfos = thread.getThreadInfo(threadIds);
            logger.info("所有线程信息:");
            logger.info("\t\t线程名称\t\t\t\t\t状态\t\t\t\t\t线程id");
            for (ThreadInfo threadInfo : threadInfos) {
                logger.info("\t\t" + threadInfo.getThreadName() + "\t\t\t\t\t"
                        + threadInfo.getThreadState() + "\t\t\t\t\t" + threadInfo.getThreadId());
            }
        }

    }

    private static boolean isSunOsMBean(OperatingSystemMXBean operatingSystem) {
        final String className = operatingSystem.getClass().getName();
        return "com.sun.management.OperatingSystem".equals(className)
                || "com.sun.management.UnixOperatingSystem".equals(className);
    }

    private JvmInfo() {
    }
}