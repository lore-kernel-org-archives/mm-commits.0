Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792797943;
	b=kWM8jbTWUVZnT+k0mFd2U6ixVNpo15V1suqKj7nu1AqESTV63p2SZ5RjQpQQp6iTgL1F
	 NFOexnJWp44iIwA6kS1dS35jGcxAXAhGISOK5psIKDIG8rIeKKEaNq1h+VFpmI1xpl/gH
	 /XWRwf+a0D/7d1mJQX3zZoZrqn1wHC9Hs+nyuVvTnE1pzFvkGKM9lFjPsy2OTnjZT0jvR
	 Xa7DTwb2S1RcNxncYNQVyIyUHbowf3qeFKXb3ih+8FXgBNmn02nKJos47Qxh2h3Kbf8PA
	 DaMcbHiJpWHqiJV+G32fPx7mA5pVdu4niu/J7Rzcwy0/Fs2+J/lBLljo8iLLTNJmYtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792797943;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+HuoTzPunyqwQnSWfifI5ct4JTEwyDyp7viE0ilpu9E=;
	b=s0FIPte36y/ZzJNodLcpAE68+srsFJOFj3CQlYpCLEk0gCyj5qnbxJEC6quOslpqJBF7
	 kkROlqn1KxVdcmoc6/ALNpAStbBPP6pBnvHq0j5iWBy5MgFLWAP3JS5YkuBRu8paSA2R5
	 qsCGZHXG8sbOz9+bq0f/3kwzR0InUSBS1R/PmC6ve7mRMTVEZaVy5TqL4kIp49piWV1Eg
	 pGvQMK0nsHGnqf3Pj4U5eoV7so5OmItdIQNz3JJlDJlGfkylchErfcNqDJ0/zxiaR45bx
	 YAcxsVnQW64rlxgbw4B8Rhz0ci7jLpgr4X1O8S/t0pB/ohx/xfPppi3r/XY4xG2RQ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RrfNLbyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA35606A330
	for <mm-commits@vger.kernel.org>; Fri, 23 Oct 2026 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RrfNLbyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB4E1F031EB;
	Fri, 23 Oct 2026 23:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792797942;
	bh=+HuoTzPunyqwQnSWfifI5ct4JTEwyDyp7viE0ilpu9E=;
	h=Date:To:From:Subject;
	b=RrfNLbyusMwGiz7wbRxXmt2JuqrGQ8esBX9zKV58gVKpmzoSbDj+kMJ8JmKTN4/Vj
	 MjjOHJnVEZc97YS4W4JXpHhP9u1xBFBekCMhGsaCJKE4BGtDL5RRZsmQLrC3/iObLP
	 WPF7/NgqX6g9lkk7eLHI+PlWEb75Ng4asuIZfEO8=
Date: Fri, 23 Oct 2026 16:25:42 -0700
To: mm-commits@vger.kernel.org,andrea.cervesato@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] maintainers-update-andrea-cervesatos-email-for-ltp.patch removed from -mm tree
Message-Id: <20261023232542.9EB4E1F031EB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
has been removed from the -mm tree.  Its filename was
     maintainers-update-andrea-cervesatos-email-for-ltp.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrea Cervesato <andrea.cervesato@suse.com>
Subject: MAINTAINERS: update Andrea Cervesato's email for LTP
Date: Fri, 23 Oct 2026 12:45:21 +0200

I'm not working for SUSE anymore and I will use linux.dev email to
develop and maintain Linux Test Project.

Link: https://lore.kernel.org/20261023-acer_maintainers-v1-1-848cf4a99a10@suse.com
Signed-off-by: Andrea Cervesato <andrea.cervesato@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-update-andrea-cervesatos-email-for-ltp
+++ a/MAINTAINERS
@@ -15570,7 +15570,7 @@ F:	Documentation/devicetree/bindings/i2c
 F:	drivers/i2c/muxes/i2c-mux-ltc4306.c
 
 LTP (Linux Test Project)
-M:	Andrea Cervesato <andrea.cervesato@suse.com>
+M:	Andrea Cervesato <andrea.cervesato@linux.dev>
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
_

Patches currently in -mm which might be from andrea.cervesato@suse.com are


