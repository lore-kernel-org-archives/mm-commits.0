From: akpm@linux-foundation.org
Subject: [merged] filemap-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:12 -0700
Message-ID: <200904141949.n3EJnC8j019431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbZDNTui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:50:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     filemap: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     filemap-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-docbooks-add-fix-pci-kernel-doc.patch
qla2x-fix-printk-format-warnings.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

