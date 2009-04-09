From: akpm@linux-foundation.org
Subject: + filemap-fix-kernel-doc-warnings.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:25:10 -0700
Message-ID: <200904092125.n39LPACf001559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120AbZDIV0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     filemap: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     filemap-fix-kernel-doc-warnings.patch

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
Subject: filemap: fix kernel-doc warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix filemap.c kernel-doc warnings:

Warning(mm/filemap.c:575): No description found for parameter 'page'
Warning(mm/filemap.c:575): No description found for parameter 'waiter'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~filemap-fix-kernel-doc-warnings mm/filemap.c
--- a/mm/filemap.c~filemap-fix-kernel-doc-warnings
+++ a/mm/filemap.c
@@ -567,8 +567,8 @@ EXPORT_SYMBOL(wait_on_page_bit);
 
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
- * @page - Page defining the wait queue of interest
- * @waiter - Waiter to add to the queue
+ * @page: Page defining the wait queue of interest
+ * @waiter: Waiter to add to the queue
  *
  * Add an arbitrary @waiter to the wait queue for the nominated @page.
  */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-fix-email-address.patch
linux-next.patch
timers-add-missing-kernel-doc.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sysctl-lockdep-support-for-sysctl-reference-counting-fix.patch
qla2x-fix-printk-format-warnings.patch
filemap-fix-kernel-doc-warnings.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix-fix.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization-fix.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

