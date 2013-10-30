From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 30 Oct 2013 16:03:57 -0700
Message-ID: <5271905d.9YMh08caA+3lVtAl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3J3XD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 19:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 16:03:57 -0700


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/perf/builtin-record.c |    9 ---------
 tools/perf/builtin-top.c    |    9 ---------
 tools/perf/util/hist.h      |    3 ---
 3 files changed, 21 deletions(-)

diff -puN tools/perf/builtin-record.c~linux-next-git-rejects tools/perf/builtin-record.c
--- a/tools/perf/builtin-record.c~linux-next-git-rejects
+++ a/tools/perf/builtin-record.c
@@ -721,15 +721,11 @@ int record_parse_callchain(const char *a
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-<<<<<<< HEAD
-#endif /* LIBUNWIND_SUPPORT */
-=======
 
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 opts->stack_dump_size);
 #endif /* HAVE_LIBUNWIND_SUPPORT */
->>>>>>> linux-next/akpm-base
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -815,13 +811,8 @@ static struct perf_record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-<<<<<<< HEAD
-#ifdef LIBUNWIND_SUPPORT
-const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
-=======
 #ifdef HAVE_LIBUNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
->>>>>>> linux-next/akpm-base
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
 #endif
diff -puN tools/perf/builtin-top.c~linux-next-git-rejects tools/perf/builtin-top.c
--- a/tools/perf/builtin-top.c~linux-next-git-rejects
+++ a/tools/perf/builtin-top.c
@@ -1110,21 +1110,12 @@ int cmd_top(int argc, const char **argv,
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-<<<<<<< HEAD
-	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
-			   NULL, "enables call-graph recording",
-			   &callchain_opt),
-	OPT_CALLBACK(0, "call-graph", &top.record_opts,
-		     "mode[,dump_size]", record_callchain_help,
-		     &parse_callchain_opt),
-=======
 	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
 			     "mode[,dump_size]", record_callchain_help,
 			     &parse_callchain_opt, "fp"),
 	OPT_INTEGER(0, "max-stack", &top.max_stack,
 		    "Set the maximum stack depth when parsing the callchain. "
 		    "Default: " __stringify(PERF_MAX_STACK_DEPTH)),
->>>>>>> linux-next/akpm-base
 	OPT_CALLBACK(0, "ignore-callees", NULL, "regex",
 		   "ignore callees of these functions in call graphs",
 		   report_parse_ignore_callees_opt),
diff -puN tools/perf/util/hist.h~linux-next-git-rejects tools/perf/util/hist.h
--- a/tools/perf/util/hist.h~linux-next-git-rejects
+++ a/tools/perf/util/hist.h
@@ -5,11 +5,8 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
-<<<<<<< HEAD
 #include "color.h"
-=======
 #include "ui/progress.h"
->>>>>>> linux-next/akpm-base
 
 extern struct callchain_param callchain_param;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix-fix.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
seq_file-remove-%n-usage-from-seq_file-users-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

