package com.example.metrics;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import io.micrometer.core.instrument.Counter;

@WebFilter("/*")
public class MetricsFilter implements Filter {

    private final Counter counter =
            Counter.builder("http_requests_total")
                   .description("Total HTTP Requests")
                   .register(MetricsRegistry.registry);

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        counter.increment();
        chain.doFilter(request, response);
    }
}
