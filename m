From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects-2.patch added to -mm tree
Date: Thu, 06 Jul 2017 15:59:50 -0700
Message-ID: <595ec0e6.mw+wpWsVuKzMl19q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752808AbdGFW7v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: a
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/apei/ghes.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN drivers/acpi/apei/ghes.c~a drivers/acpi/apei/ghes.c
--- a/drivers/acpi/apei/ghes.c~a
+++ a/drivers/acpi/apei/ghes.c
@@ -1098,14 +1098,6 @@ static int ghes_probe(struct platform_de
 	case ACPI_HEST_NOTIFY_GSIV:
 	case ACPI_HEST_NOTIFY_GPIO:
 		break;
-	case ACPI_HEST_NOTIFY_SEA:
-		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
-			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEA is not supported\n",
-				generic->header.source_id);
-			rc = -ENOTSUPP;
-			goto err;
-		}
-		break;
 
 	case ACPI_HEST_NOTIFY_SEA:
 		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
@@ -1185,10 +1177,6 @@ static int ghes_probe(struct platform_de
 	case ACPI_HEST_NOTIFY_SEA:
 		ghes_sea_add(ghes);
 		break;
-
-	case ACPI_HEST_NOTIFY_SEA:
-		ghes_sea_add(ghes);
-		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1241,10 +1229,6 @@ static int ghes_remove(struct platform_d
 	case ACPI_HEST_NOTIFY_SEA:
 		ghes_sea_remove(ghes);
 		break;
-
-	case ACPI_HEST_NOTIFY_SEA:
-		ghes_sea_remove(ghes);
-		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects-2.patch

