From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 21 Dec 2017 12:04:14 -0800
Message-ID: <20171221200414.-2G4klAfw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdLUUEQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Dec 2017 15:04:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/x86/kvm/x86.c~linux-next-git-rejects arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~linux-next-git-rejects
+++ a/arch/x86/kvm/x86.c
@@ -7336,10 +7336,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_v
 {
 	int r;
 
-<<<<<<< HEAD
-=======
 	vcpu_load(vcpu);
->>>>>>> linux-next/akpm-base
 	kvm_sigset_activate(vcpu);
 	kvm_load_guest_fpu(vcpu);
 
diff -puN tools/kvm/kvm_stat/kvm_stat~linux-next-git-rejects tools/kvm/kvm_stat/kvm_stat
--- a/tools/kvm/kvm_stat/kvm_stat~linux-next-git-rejects
+++ a/tools/kvm/kvm_stat/kvm_stat
@@ -1579,15 +1579,6 @@ def main():
 
     stats = Stats(options)
 
-<<<<<<< HEAD
-    if options.fields == 'help':
-        stats.fields_filter = None
-        event_list = []
-        for key in stats.get().keys():
-            event_list.append(key.split('(', 1)[0])
-        sys.stdout.write('  ' + '\n  '.join(sorted(set(event_list))) + '\n')
-        sys.exit(0)
-=======
     if options.fields == "help":
         stats.fields_filter = None
         event_list = "\n"
@@ -1599,7 +1590,6 @@ def main():
                 event_list += key + '\n'
         sys.stdout.write(event_list)
         return ""
->>>>>>> linux-next/akpm-base
 
     if options.log:
         log(stats)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-exitc-export-abort-to-modules.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

