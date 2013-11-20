From: akpm@linux-foundation.org
Subject: + maintainers-add-keyboard-driver-to-hyper-v-file-list.patch
 added to -mm tree
Date: Wed, 20 Nov 2013 14:54:02 -0800
Message-ID: <528d3d8a.W47/USLcj3Fi7wUs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3KTWyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 17:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kys@microsoft.com, dmitry.torokhov@gmail.com, haiyangz@microsoft.com

Subject: + maintainers-add-keyboard-driver-to-hyper-v-file-list.patch added to -mm tree
To: haiyangz@microsoft.com,dmitry.torokhov@gmail.com,kys@microsoft.com
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 14:54:02 -0800


The patch titled
     Subject: MAINTAINERS: add keyboard driver to Hyper-V file list
has been added to the -mm tree.  Its filename is
     maintainers-add-keyboard-driver-to-hyper-v-file-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-keyboard-driver-to-hyper-v-file-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-keyboard-driver-to-hyper-v-file-list.patch

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
maintainers-add-keyboard-driver-to-hyper-v-file-list.patch

