From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-keyboard-driver-to-hyper-v-file-list.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:22:05 -0800
Message-ID: <528fcafd.jT5XJ1ozVZcxLkzj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3KVVWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kys@microsoft.com, dmitry.torokhov@gmail.com, haiyangz@microsoft.com

Subject: [merged] maintainers-add-keyboard-driver-to-hyper-v-file-list.patch removed from -mm tree
To: haiyangz@microsoft.com,dmitry.torokhov@gmail.com,kys@microsoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:22:05 -0800


The patch titled
     Subject: MAINTAINERS: add keyboard driver to Hyper-V file list
has been removed from the -mm tree.  Its filename was
     maintainers-add-keyboard-driver-to-hyper-v-file-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haiyang Zhang <haiyangz@microsoft.com>
Subject: MAINTAINERS: add keyboard driver to Hyper-V file list

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-keyboard-driver-to-hyper-v-file-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-keyboard-driver-to-hyper-v-file-list
+++ a/MAINTAINERS
@@ -4065,6 +4065,7 @@ F:	arch/x86/include/uapi/asm/hyperv.h
 F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
+F:	drivers/input/serio/hyperv-keyboard.c
 F:	drivers/net/hyperv/
 F:	drivers/scsi/storvsc_drv.c
 F:	drivers/video/hyperv_fb.c
_

Patches currently in -mm which might be from haiyangz@microsoft.com are

origin.patch
linux-next.patch

