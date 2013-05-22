From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-hyper-v-file-list.patch removed from
 -mm tree
Date: Wed, 22 May 2013 12:33:16 -0700
Message-ID: <519d1d7c.e76XdAF1H6knhpLj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EVTdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 15:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com

Subject: [merged] maintainers-update-hyper-v-file-list.patch removed from -mm tree
To: haiyangz@microsoft.com,kys@microsoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 12:33:16 -0700


The patch titled
     Subject: MAINTAINERS: update Hyper-V file list
has been removed from the -mm tree.  Its filename was
     maintainers-update-hyper-v-file-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: MAINTAINERS: update Hyper-V file list

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-hyper-v-file-list MAINTAINERS
--- a/MAINTAINERS~maintainers-update-hyper-v-file-list
+++ a/MAINTAINERS
@@ -3865,9 +3865,16 @@ M:	K. Y. Srinivasan <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
 L:	devel@linuxdriverproject.org
 S:	Maintained
-F:	drivers/hv/
+F:	arch/x86/include/asm/mshyperv.h
+F:	arch/x86/include/uapi/asm/hyperv.h
+F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/hid/hid-hyperv.c
+F:	drivers/hv/
 F:	drivers/net/hyperv/
+F:	drivers/scsi/storvsc_drv.c
+F:	drivers/video/hyperv_fb.c
+F:	include/linux/hyperv.h
+F:	tools/hv/
 
 I2C OVER PARALLEL PORT
 M:	Jean Delvare <khali@linux-fr.org>
_

Patches currently in -mm which might be from haiyangz@microsoft.com are

linux-next.patch

