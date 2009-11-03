From: akpm@linux-foundation.org
Subject: + security-min_addrc-make-init_mmap_min_addr-static.patch added to -mm tree
Date: Mon, 02 Nov 2009 22:08:05 -0800
Message-ID: <200911030608.nA3685fW023994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbZKCGIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 01:08:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com, jmorris@namei.org


The patch titled
     security/min_addr.c: make init_mmap_min_addr() static
has been added to the -mm tree.  Its filename is
     security-min_addrc-make-init_mmap_min_addr-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: security/min_addr.c: make init_mmap_min_addr() static
From: "H Hartley Sweeten" <hartleys@visionengravers.com>

init_mmap_min_addr() is a pure_initcall and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/min_addr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/min_addr.c~security-min_addrc-make-init_mmap_min_addr-static security/min_addr.c
--- a/security/min_addr.c~security-min_addrc-make-init_mmap_min_addr-static
+++ a/security/min_addr.c
@@ -40,7 +40,7 @@ int mmap_min_addr_handler(struct ctl_tab
 	return ret;
 }
 
-int __init init_mmap_min_addr(void)
+static int __init init_mmap_min_addr(void)
 {
 	update_mmap_min_addr();
 
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

origin.patch
linux-next.patch
clockeventsc-fix-symbol-was-not-declared-noise.patch
drivers-usb-core-hcdc-quiet-null-pointer-sparse-noise.patch
security-min_addrc-make-init_mmap_min_addr-static.patch
drivers-misc-add-driver-for-texas-instruments-dac7512.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
init-mainc-fix-symbol-shadows-noise.patch
kernel-sysc-fix-warning-do-while-statement-is-not-a-compound-statement-noise.patch

