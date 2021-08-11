package com.dreamless.todo.config;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
import org.springframework.validation.BindingResult;

@Component
@Aspect
public class AopConfig {
    private static final Logger logger = LogManager.getLogger(AopConfig.class);

    @Pointcut("execution(public * com.dreamless.todo.controller..*.*(..))")
    public void log() {
    }

    /**
     * 前置通知
     *
     * @param joinPoint
     */
    @Before("log()")
    public void doBefore(JoinPoint joinPoint) {
        System.out.println("doBefore");
    }

    @Around("log()")
    public Object doAround(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        System.out.println("doAround");
        BindingResult bindingResult = null;
        for (Object arg :
                proceedingJoinPoint.getArgs()) {
            if (arg instanceof BindingResult) {
                bindingResult = (BindingResult) arg;
            }
        }
        if (bindingResult != null && bindingResult.getErrorCount() > 0) {
            return ApiResult.error( bindingResult.getAllErrors().get(0).getDefaultMessage());
        }

        return proceedingJoinPoint.proceed();
    }

    @AfterThrowing(value = "log()", throwing = "exception")
    public void doAfterThrowing(JoinPoint joinPoint, Exception exception) {
        System.out.println("doAfterThrowing");
        logger.error(exception);
    }


}
