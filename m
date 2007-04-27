From: akpm@linux-foundation.org
Subject: - smaps-add-clear_refs-file-to-clear-reference-docs.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:12:54 -0700
Message-ID: <200704270812.l3R8Cs41023015@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755500AbXD0INA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     smaps: add documentation for clear_refs
has been removed from the -mm tree.  Its filename was
     smaps-add-clear_refs-file-to-clear-reference-docs.patch

This patch was dropped because it was folded into smaps-add-clear_refs-file-to-clear-reference.patch

------------------------------------------------------
Subject: smaps: add documentation for clear_refs
From: David Rientjes <rientjes@google.com>

Adds documentation for new /proc/pid/clear_refs file.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   31 +++++++++++++--------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff -puN Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference-docs Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~smaps-add-clear_refs-file-to-clear-reference-docs
+++ a/Documentation/filesystems/proc.txt
@@ -122,21 +122,22 @@ subdirectory has the entries listed in T
 
 Table 1-1: Process specific entries in /proc 
 ..............................................................................
- File    Content                                        
- cmdline Command line arguments                         
- cpu	 Current and last cpu in which it was executed		(2.4)(smp)
- cwd	 Link to the current working directory
- environ Values of environment variables      
- exe	 Link to the executable of this process
- fd      Directory, which contains all file descriptors 
- maps	 Memory maps to executables and library files		(2.4)
- mem     Memory held by this process                    
- root	 Link to the root directory of this process
- stat    Process status                                 
- statm   Process memory status information              
- status  Process status in human readable form          
- wchan   If CONFIG_KALLSYMS is set, a pre-decoded wchan
- smaps	 Extension based on maps, presenting the rss size for each mapped file
+ File		Content
+ clear_refs	Clears page referenced bits shown in smaps output
+ cmdline	Command line arguments
+ cpu		Current and last cpu in which it was executed	(2.4)(smp)
+ cwd		Link to the current working directory
+ environ	Values of environment variables
+ exe		Link to the executable of this process
+ fd		Directory, which contains all file descriptors
+ maps		Memory maps to executables and library files	(2.4)
+ mem		Memory held by this process
+ root		Link to the root directory of this process
+ stat		Process status
+ statm		Process memory status information
+ status		Process status in human readable form
+ wchan		If CONFIG_KALLSYMS is set, a pre-decoded wchan
+ smaps		Extension based on maps, the rss size for each mapped file
 ..............................................................................
 
 For example, to get the status information of a process, all you have to do is
_

Patches currently in -mm which might be from rientjes@google.com are

slab-x86_64-skip-cache_free_alien-on-non-numa.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
cpusets-allow-tif_memdie-threads-to-allocate-anywhere.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
oom-fix-constraint-deadlock.patch
