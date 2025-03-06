Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ADC19E98B
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 05:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239477; cv=none; b=f1PrtahjIy1hVh8rmf4VP5r8OZqEkNzc9D7ftO/vejI/Auv1KNekT+IeLBWJ7hhpFyIETWfR6by8mLwYKaO+Z2rj1hrjNVZ15DDKT+YB4JcFzIXt9MzBBUYBIO5cmKQYm5i6A9UkU5u627VXJLTVUqk2pCZrzs93kW2f+x7rxeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239477; c=relaxed/simple;
	bh=pen8Re400Cd6NgE43qxaHsCPV4PaoP4aQxVlguLcFzc=;
	h=Date:To:From:Subject:Message-Id; b=EiJGcpt4jxs6u3xywVEsI/dO+U13HLrIpppxMmzAeOf+wcKvciUex0PeHuHjIHH9m0oQIv72qbCzrDJBE/BRqd4zHzrryQ0G2xhXp3Ku+nnpmmrEUR0pgIPKLJYhi1dnrenWdiq84KLuRMuTlAGIAKkmJVJ4qu45PkMUnaRz8YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mbtngt3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mbtngt3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37497C4CEE4;
	Thu,  6 Mar 2025 05:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239477;
	bh=pen8Re400Cd6NgE43qxaHsCPV4PaoP4aQxVlguLcFzc=;
	h=Date:To:From:Subject:From;
	b=mbtngt3uqHR8QYq/FgHFsqNNv61XvJeLPKPc46wq09Vjp8K38ACjk/8JSSrE6W9M/
	 M3iB8cHRG8146gfv1ulmevfoYMp04KaCKX7HZgIOgMBsN0iXZGiK5odoFMJZ4zbhc6
	 0hwjtDtQkbxWDPhOMrvw9OvKAjXe/b/bpxxLorX8=
Date: Wed, 05 Mar 2025 21:37:56 -0800
To: mm-commits@vger.kernel.org,jens.wiklander@linaro.org,jarkko@kernel.org,herbert@gondor.apana.org.au,sumit.garg@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-sumit-gargs-email-address.patch removed from -mm tree
Message-Id: <20250306053757.37497C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: .mailmap: update Sumit Garg's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-sumit-gargs-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumit Garg <sumit.garg@linaro.org>
Subject: MAINTAINERS: .mailmap: update Sumit Garg's email address
Date: Thu, 27 Feb 2025 17:02:28 +0530

Update Sumit Garg's email address to @kernel.org.

Link: https://lkml.kernel.org/r/20250227113228.1809449-1-sumit.garg@linaro.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-mailmap-update-sumit-gargs-email-address
+++ a/.mailmap
@@ -689,6 +689,7 @@ Subbaraman Narayanamurthy <quic_subbaram
 Subhash Jadavani <subhashj@codeaurora.org>
 Sudarshan Rajagopalan <quic_sudaraja@quicinc.com> <sudaraja@codeaurora.org>
 Sudeep Holla <sudeep.holla@arm.com> Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+Sumit Garg <sumit.garg@kernel.org> <sumit.garg@linaro.org>
 Sumit Semwal <sumit.semwal@ti.com>
 Surabhi Vishnoi <quic_svishnoi@quicinc.com> <svishnoi@codeaurora.org>
 Sven Eckelmann <sven@narfation.org> <seckelmann@datto.com>
--- a/MAINTAINERS~maintainers-mailmap-update-sumit-gargs-email-address
+++ a/MAINTAINERS
@@ -12864,7 +12864,7 @@ F:	include/keys/trusted_dcp.h
 F:	security/keys/trusted-keys/trusted_dcp.c
 
 KEYS-TRUSTED-TEE
-M:	Sumit Garg <sumit.garg@linaro.org>
+M:	Sumit Garg <sumit.garg@kernel.org>
 L:	linux-integrity@vger.kernel.org
 L:	keyrings@vger.kernel.org
 S:	Supported
@@ -17658,7 +17658,7 @@ F:	Documentation/ABI/testing/sysfs-bus-o
 F:	drivers/tee/optee/
 
 OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
-M:	Sumit Garg <sumit.garg@linaro.org>
+M:	Sumit Garg <sumit.garg@kernel.org>
 L:	op-tee@lists.trustedfirmware.org
 S:	Maintained
 F:	drivers/char/hw_random/optee-rng.c
@@ -23268,7 +23268,7 @@ F:	include/media/i2c/tw9910.h
 
 TEE SUBSYSTEM
 M:	Jens Wiklander <jens.wiklander@linaro.org>
-R:	Sumit Garg <sumit.garg@linaro.org>
+R:	Sumit Garg <sumit.garg@kernel.org>
 L:	op-tee@lists.trustedfirmware.org
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-class-tee
_

Patches currently in -mm which might be from sumit.garg@linaro.org are


