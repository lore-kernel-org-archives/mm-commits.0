From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch removed from -mm
 tree
Date: Fri, 06 Jun 2014 14:10:38 -0700
Message-ID: <53922e4e.lJSvMt4vb7ZL+pE4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40214 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaFFVKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2014 17:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, kirill.shutemov@linux.intel.com, davej@redhat.com, arigo@tunes.org, akpm@linux-foundation.org

Subject: [folded-merged] mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,arigo@tunes.org,davej@redhat.com,kirill.shutemov@linux.intel.com,mingo@kernel.org,peterz@infradead.org,torvalds@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 06 Jun 2014 14:10:38 -0700


The patch titled
     Subject: mm-mark-remap_file_pages-syscall-as-deprecated-fix
has been removed from the -mm tree.  Its filename was
     mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch

This patch was dropped because it was folded into mm-mark-remap_file_pages-syscall-as-deprecated.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mark-remap_file_pages-syscall-as-deprecated-fix

fix spello

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Armin Rigo <arigo@tunes.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated-fix mm/fremap.c
--- a/mm/fremap.c~mm-mark-remap_file_pages-syscall-as-deprecated-fix
+++ a/mm/fremap.c
@@ -149,7 +149,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	int has_write_lock = 0;
 	vm_flags_t vm_flags = 0;
 
-	pr_warn_once("%s (%d) uses depricated remap_file_pages() syscall. "
+	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
 			"See Documentation/vm/remap_file_pages.txt.\n",
 			current->comm, current->pid);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support.patch
rtc-da9063-rtc-driver.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
sysctl-allow-for-strict-write-position-handling.patch
fs-pstore-logging-clean-up.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch

