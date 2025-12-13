package com.ice.sparkhire.config;

import com.qcloud.cos.COSClient;
import com.qcloud.cos.ClientConfig;
import com.qcloud.cos.auth.BasicCOSCredentials;
import com.qcloud.cos.auth.COSCredentials;
import com.qcloud.cos.region.Region;
import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * @author <a href="https://github.com/Ice-Programmer">chenjiahan</a>
 * @create 2025/12/13 14:39
 */
@Configuration
@Data
public class CosConfig {

    /**
     * accessKey
     **/
    @Value("${cos.client.accessKey}")
    private String accessKey;

    /**
     * secretKey
     **/
    @Value("${cos.client.secret-key}")
    private String secretKey;

    /**
     * region
     **/
    @Value("${cos.client.region}")
    private String region;

    /**
     * bucket
     **/
    @Value("${cos.client.bucket}")
    private String bucket;

    /**
     * Host
     */
    @Value("${cos.client.host}")
    private String host;

    @Bean
    public COSClient cosClient() {
        COSCredentials cred = new BasicCOSCredentials(accessKey, secretKey);
        ClientConfig clientConfig = new ClientConfig(new Region(region));
        return new COSClient(cred, clientConfig);
    }
}
