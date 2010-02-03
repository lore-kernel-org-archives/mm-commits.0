From: akpm@linux-foundation.org
Subject: [merged] kfifo-fix-kernel-doc-notation.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:54:43 -0800
Message-ID: <201002031754.o13HshMh008914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932778Ab0BCRza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 12:55:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: fix kernel-doc notation
has been removed from the -mm tree.  Its filename was
     kfifo-fix-kernel-doc-notation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kfifo kernel-doc warnings:

Warning(kernel/kfifo.c:361): No description found for parameter 'total'
Warning(kernel/kfifo.c:402): bad line:  @ @lenout: pointer to output variable with copied data
Warning(kernel/kfifo.c:412): No description found for parameter 'lenout'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kfifo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kfifo.c~kfifo-fix-kernel-doc-notation kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-fix-kernel-doc-notation
+++ a/kernel/kfifo.c
@@ -349,6 +349,7 @@ EXPORT_SYMBOL(__kfifo_from_user_n);
  * @fifo: the fifo to be used.
  * @from: pointer to the data to be added.
  * @len: the length of the data to be added.
+ * @total: the actual returned data length.
  *
  * This function copies at most @len bytes from the @from into the
  * FIFO depending and returns -EFAULT/0.
@@ -399,7 +400,7 @@ EXPORT_SYMBOL(__kfifo_to_user_n);
  * @fifo: the fifo to be used.
  * @to: where the data must be copied.
  * @len: the size of the destination buffer.
- @ @lenout: pointer to output variable with copied data
+ * @lenout: pointer to output variable with copied data
  *
  * This function copies at most @len bytes from the FIFO into the
  * @to buffer and 0 or -EFAULT.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
ati_pcigart-fix-printk-format-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

