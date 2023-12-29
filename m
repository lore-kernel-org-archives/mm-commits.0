Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1681426D
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BdvNT37o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB1C433C7;
	Fri, 29 Dec 2023 20:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881389;
	bh=UR/eYY++mlORsH1liYiT/bLf8oufhf+AUnfbEttK7aI=;
	h=Date:To:From:Subject:From;
	b=BdvNT37oWcTSe4kWoFv2fGNA436dwbK95cFbrRTBxiNO1Gwtix1rF+YgPnuo7Bef3
	 mU6NAbeKgRd0jwW5EYW9oKrAF2+r1EvIo0Mjk96M9yc2mSu3qStgIQYOasbCxh1Zq1
	 7s6zDrKrs5KbSfYxhFF5KCicwLGBxqFQ0AW+ruBk=
Date: Fri, 29 Dec 2023 12:23:08 -0800
To: mm-commits@vger.kernel.org,ohad@wizery.com,mathieu.poirier@linaro.org,baolin.wang@linux.alibaba.com,andersson@kernel.org,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-remove-ohad-ben-cohen-from-hwspinlock-subsystem.patch removed from -mm tree
Message-Id: <20231229202309.3FDB1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: remove Ohad Ben-Cohen from hwspinlock subsystem
has been removed from the -mm tree.  Its filename was
     maintainers-remove-ohad-ben-cohen-from-hwspinlock-subsystem.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: MAINTAINERS: remove Ohad Ben-Cohen from hwspinlock subsystem
Date: Mon, 18 Dec 2023 20:28:31 +0700

Commit 62c46d55688894 ("MAINTAINERS: Removing Ohad from remoteproc/rpmsg
maintenance") removes his MAINTAINERS entry in regards to remoteproc
subsystem due to his inactivity (the last commit with his Signed-off-by is
99c429cb4e628e ("remoteproc/wkup_m3: Use MODULE_DEVICE_TABLE to export
alias") which is authored in 2015 and his last LKML message prior to
62c46d55688894 was [1]).

Remove also his MAINTAINERS entry for hwspinlock subsystem as there is no
point of Cc'ing maintainers who never respond in a long time.

[1]: https://lore.kernel.org/r/CAK=Wgbbcyi36ef1-PV8VS=M6nFoQnFGUDWy6V7OCnkt0dDrtfg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20231218132830.5104-2-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Ohad Ben Cohen <ohad@wizery.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    3 +++
 MAINTAINERS |    4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/CREDITS~maintainers-remove-ohad-ben-cohen-from-hwspinlock-subsystem
+++ a/CREDITS
@@ -323,6 +323,9 @@ N: Ohad Ben Cohen
 E: ohad@wizery.com
 D: Remote Processor (remoteproc) subsystem
 D: Remote Processor Messaging (rpmsg) subsystem
+D: Hardware spinlock (hwspinlock) subsystem
+D: OMAP hwspinlock driver
+D: OMAP remoteproc driver
 
 N: Krzysztof Benedyczak
 E: golbi@mat.uni.torun.pl
--- a/MAINTAINERS~maintainers-remove-ohad-ben-cohen-from-hwspinlock-subsystem
+++ a/MAINTAINERS
@@ -9257,7 +9257,6 @@ F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
 HARDWARE SPINLOCK CORE
-M:	Ohad Ben-Cohen <ohad@wizery.com>
 M:	Bjorn Andersson <andersson@kernel.org>
 R:	Baolin Wang <baolin.wang7@gmail.com>
 L:	linux-remoteproc@vger.kernel.org
@@ -15692,9 +15691,8 @@ F:	Documentation/devicetree/bindings/gpi
 F:	drivers/gpio/gpio-omap.c
 
 OMAP HARDWARE SPINLOCK SUPPORT
-M:	Ohad Ben-Cohen <ohad@wizery.com>
 L:	linux-omap@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/hwspinlock/omap_hwspinlock.c
 
 OMAP HS MMC SUPPORT
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


