From: akpm@linux-foundation.org
Subject: [merged] drivers-rapidio-rio-scanc-make-functions-static.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:33 -0700
Message-ID: <51db14c1.4YTUQXYhrRlviiY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, Alexandre.Bounine@idt.com, fengguang.wu@intel.com

Subject: [merged] drivers-rapidio-rio-scanc-make-functions-static.patch removed from -mm tree
To: fengguang.wu@intel.com,Alexandre.Bounine@idt.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:33 -0700


The patch titled
     Subject: drivers/rapidio/rio-scan.c: make functions static
has been removed from the -mm tree.  Its filename was
     drivers-rapidio-rio-scanc-make-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: drivers/rapidio/rio-scan.c: make functions static

sparse warnings:

drivers/rapidio/rio-scan.c:1143:5: sparse: symbol 'rio_enum_mport' was not declared. Should it be static?
drivers/rapidio/rio-scan.c:1246:5: sparse: symbol 'rio_disc_mport' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-make-functions-static drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~drivers-rapidio-rio-scanc-make-functions-static
+++ a/drivers/rapidio/rio-scan.c
@@ -1141,7 +1141,7 @@ static void rio_pw_enable(struct rio_mpo
  * link, then start recursive peer enumeration. Returns %0 if
  * enumeration succeeds or %-EBUSY if enumeration fails.
  */
-int rio_enum_mport(struct rio_mport *mport, u32 flags)
+static int rio_enum_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	int rc = 0;
@@ -1256,7 +1256,7 @@ static void rio_build_route_tables(struc
  * peer discovery. Returns %0 if discovery succeeds or %-EBUSY
  * on failure.
  */
-int rio_disc_mport(struct rio_mport *mport, u32 flags)
+static int rio_disc_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	unsigned long to_end;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid-v2-fix.patch
zswap-add-to-mm-fix-kconfig-to-depend-on-crypto=y.patch
fs-fs-writebackc-make-wb_do_writeback-as-static.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix.patch
memcg-use-css_get-put-when-charging-uncharging-kmem-fix-fix-fix.patch
smp-give-warning-when-calling-smp_call_function_many-single-in-serving-irq.patch
fat-additions-to-support-fat_fallocate-fix.patch
ipc-move-rcu-lock-out-of-ipc_addid-restore-rcu-locking-in-ipc_addid.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-fix-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
debugging-keep-track-of-page-owner-now-depends-on-stacktrace_support.patch

