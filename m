From: akpm@linux-foundation.org
Subject: + maintainers-update-hyper-v-file-list.patch added to -mm tree
Date: Thu, 09 May 2013 14:09:09 -0700
Message-ID: <20130509210909.6CC2531C08F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:50993 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3EIVJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 17:09:10 -0400
Received: by mail-qa0-f73.google.com with SMTP id bs12so863qab.4
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 14:09:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com


The patch titled
     Subject: MAINTAINERS: update Hyper-V file list
has been added to the -mm tree.  Its filename is
     maintainers-update-hyper-v-file-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
maintainers-update-hyper-v-file-list.patch

