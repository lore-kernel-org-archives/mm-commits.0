Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC3623E34E
	for <mm-commits@vger.kernel.org>; Thu, 27 Feb 2025 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697665; cv=none; b=NwqvraOQTwImg7RgcnXUCfR3QK2W8szeEUNgnX5NZuL9sCcPpKMscbRqWscQWuYGKNq0dOiVpB2yhY6s7ouQKAwS1LyZebVrZ7M1r6kT0kBdcEE/WVwMeG5sd+hw7aK+J51JS7Sqla6u369FtU82zuGGMKn0wdhtjzlk2ovmIbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697665; c=relaxed/simple;
	bh=mIJGnq9EMdWW6hK57R41B5KeSTyIbYxjYlFPOqi6y0w=;
	h=Date:To:From:Subject:Message-Id; b=AS87ukUEpFbN03Z6Wt0fFWHRCQsIXegFn8pEV8ol2O6LDEY7wZP2n9+UfLeMq9vr11pnU5RB/fVKg65hQ13Eme/Z7E1136A9s5+596zjqahk4cX8LkeIuKS+Ey/hV6Ggv+fdAG1vjW2K0qxlnKMjLUWn6NU6fbAAGbjhYSMAYxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GtLux/X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtLux/X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDA2C4CEDD;
	Thu, 27 Feb 2025 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740697664;
	bh=mIJGnq9EMdWW6hK57R41B5KeSTyIbYxjYlFPOqi6y0w=;
	h=Date:To:From:Subject:From;
	b=GtLux/X7V5wvOBAf9cag0tjP99H4oZ6Vsz7bmRC/qzsTlZBEwJtIHbhw0TAQCDiHX
	 DLBbMPQewLeD4wWVT1YfJ9ymy4UXXvTn8SxemrA5QpmhOQ4914V8WZLkZB1CHOoqqU
	 4/9jNvi8Xx90AdQaixfmK1sqEaAQPrR1NM/etOJc=
Date: Thu, 27 Feb 2025 15:07:44 -0800
To: mm-commits@vger.kernel.org,jens.wiklander@linaro.org,jarkko@kernel.org,herbert@gondor.apana.org.au,sumit.garg@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-sumit-gargs-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250227230744.9EDA2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: .mailmap: update Sumit Garg's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-sumit-gargs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-sumit-gargs-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

maintainers-mailmap-update-sumit-gargs-email-address.patch

