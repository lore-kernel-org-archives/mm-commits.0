From: akpm@linux-foundation.org
Subject: [nacked] rwsem-implement-rwsem_is_contended-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Dec 2010 16:56:54 -0800
Message-ID: <201012140056.oBE0usHR022480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754518Ab0LNA46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 19:56:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     rwsem-implement-rwsem_is_contended-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rwsem-implement-rwsem_is_contended-checkpatch-fixes.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem-implement-rwsem_is_contended-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#39: FILE: arch/alpha/include/asm/rwsem.h:260:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#39: FILE: arch/alpha/include/asm/rwsem.h:260:
+        return (sem->count < 0);$

ERROR: code indent should use tabs where possible
#53: FILE: arch/ia64/include/asm/rwsem.h:184:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#53: FILE: arch/ia64/include/asm/rwsem.h:184:
+        return (sem->count < 0);$

ERROR: code indent should use tabs where possible
#66: FILE: arch/powerpc/include/asm/rwsem.h:184:
+        return sem->count < 0;$

WARNING: please, no spaces at the start of a line
#66: FILE: arch/powerpc/include/asm/rwsem.h:184:
+        return sem->count < 0;$

ERROR: code indent should use tabs where possible
#80: FILE: arch/s390/include/asm/rwsem.h:387:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#80: FILE: arch/s390/include/asm/rwsem.h:387:
+        return (sem->count < 0);$

ERROR: code indent should use tabs where possible
#94: FILE: arch/sh/include/asm/rwsem.h:189:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#94: FILE: arch/sh/include/asm/rwsem.h:189:
+        return (sem->count < 0);$

ERROR: code indent should use tabs where possible
#108: FILE: arch/sparc/include/asm/rwsem.h:170:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#108: FILE: arch/sparc/include/asm/rwsem.h:170:
+        return (sem->count < 0);$

ERROR: code indent should use tabs where possible
#137: FILE: arch/xtensa/include/asm/rwsem.h:170:
+        return (sem->count < 0);$

WARNING: please, no spaces at the start of a line
#137: FILE: arch/xtensa/include/asm/rwsem.h:170:
+        return (sem->count < 0);$

total: 7 errors, 7 warnings, 104 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/rwsem-implement-rwsem_is_contended.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/rwsem.h   |    2 +-
 arch/ia64/include/asm/rwsem.h    |    2 +-
 arch/powerpc/include/asm/rwsem.h |    2 +-
 arch/s390/include/asm/rwsem.h    |    2 +-
 arch/sh/include/asm/rwsem.h      |    2 +-
 arch/sparc/include/asm/rwsem.h   |    2 +-
 arch/xtensa/include/asm/rwsem.h  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/alpha/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/alpha/include/asm/rwsem.h
--- a/arch/alpha/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/alpha/include/asm/rwsem.h
@@ -257,7 +257,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif /* __KERNEL__ */
diff -puN arch/ia64/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/ia64/include/asm/rwsem.h
--- a/arch/ia64/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/ia64/include/asm/rwsem.h
@@ -181,7 +181,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif /* _ASM_IA64_RWSEM_H */
diff -puN arch/powerpc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/powerpc/include/asm/rwsem.h
--- a/arch/powerpc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/powerpc/include/asm/rwsem.h
@@ -181,7 +181,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return sem->count < 0;
+	return sem->count < 0;
 }
 
 #endif	/* __KERNEL__ */
diff -puN arch/s390/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/s390/include/asm/rwsem.h
--- a/arch/s390/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/s390/include/asm/rwsem.h
@@ -384,7 +384,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif /* __KERNEL__ */
diff -puN arch/sh/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/sh/include/asm/rwsem.h
--- a/arch/sh/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/sh/include/asm/rwsem.h
@@ -186,7 +186,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif /* __KERNEL__ */
diff -puN arch/sparc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/sparc/include/asm/rwsem.h
--- a/arch/sparc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/sparc/include/asm/rwsem.h
@@ -167,7 +167,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif /* __KERNEL__ */
diff -puN arch/xtensa/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes arch/xtensa/include/asm/rwsem.h
--- a/arch/xtensa/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended-checkpatch-fixes
+++ a/arch/xtensa/include/asm/rwsem.h
@@ -167,7 +167,7 @@ static inline int rwsem_is_locked(struct
 
 static inline int rwsem_is_contended(struct rw_semaphore *sem)
 {
-        return (sem->count < 0);
+	return (sem->count < 0);
 }
 
 #endif	/* _XTENSA_RWSEM_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-install_special_mapping-skips-security_file_mmap-check-fix.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
headers_check-better-search-for-functions-in-headers-fix.patch
headers_check-better-search-for-functions-in-headers-fix-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-async-pps-event-handler-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

