From: akpm@linux-foundation.org
Subject: [merged] uml-remove-useless-comments.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:31 -0700
Message-ID: <200904011839.n31IdVUs008717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932868AbZDASm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove useless comments
has been removed from the -mm tree.  Its filename was
     uml-remove-useless-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: remove useless comments
From: WANG Cong <xiyou.wangcong@gmail.com>

These comments are useless now, remove them.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/pcap_user.h                |   10 ----------
 arch/um/drivers/port.h                     |   10 ----------
 arch/um/drivers/ssl.h                      |   10 ----------
 arch/um/drivers/stdio_console.h            |   10 ----------
 arch/um/drivers/xterm.h                    |   10 ----------
 arch/um/include/asm/irq_vectors.h          |   10 ----------
 arch/um/include/asm/mmu.h                  |   10 ----------
 arch/um/include/asm/pda.h                  |   10 ----------
 arch/um/include/asm/pgalloc.h              |   10 ----------
 arch/um/include/asm/pgtable-3level.h       |   10 ----------
 arch/um/include/shared/frame_kern.h        |   10 ----------
 arch/um/include/shared/initrd.h            |   10 ----------
 arch/um/include/shared/irq_kern.h          |   10 ----------
 arch/um/include/shared/mem_kern.h          |   10 ----------
 arch/um/include/shared/ubd_user.h          |   10 ----------
 arch/um/kernel/config.c.in                 |   10 ----------
 arch/um/sys-i386/asm/archparam.h           |   10 ----------
 arch/um/sys-i386/shared/sysdep/checksum.h  |   10 ----------
 arch/um/sys-ia64/sysdep/ptrace.h           |   10 ----------
 arch/um/sys-ia64/sysdep/sigcontext.h       |   10 ----------
 arch/um/sys-ia64/sysdep/syscalls.h         |   10 ----------
 arch/um/sys-ppc/miscthings.c               |   11 -----------
 arch/um/sys-ppc/ptrace.c                   |   10 ----------
 arch/um/sys-ppc/ptrace_user.c              |   10 ----------
 arch/um/sys-ppc/shared/sysdep/ptrace.h     |   10 ----------
 arch/um/sys-ppc/shared/sysdep/sigcontext.h |   10 ----------
 arch/um/sys-ppc/shared/sysdep/syscalls.h   |   10 ----------
 arch/um/sys-ppc/sigcontext.c               |   10 ----------
 arch/um/sys-x86_64/asm/archparam.h         |   10 ----------
 arch/um/sys-x86_64/asm/module.h            |   10 ----------
 arch/um/sys-x86_64/mem.c                   |    9 ---------
 31 files changed, 310 deletions(-)

diff -puN arch/um/drivers/pcap_user.h~uml-remove-useless-comments arch/um/drivers/pcap_user.h
--- a/arch/um/drivers/pcap_user.h~uml-remove-useless-comments
+++ a/arch/um/drivers/pcap_user.h
@@ -19,13 +19,3 @@ extern const struct net_user_info pcap_u
 
 extern int pcap_user_read(int fd, void *buf, int len, struct pcap_data *pri);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/port.h~uml-remove-useless-comments arch/um/drivers/port.h
--- a/arch/um/drivers/port.h~uml-remove-useless-comments
+++ a/arch/um/drivers/port.h
@@ -18,13 +18,3 @@ extern void port_remove_dev(void *d);
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/ssl.h~uml-remove-useless-comments arch/um/drivers/ssl.h
--- a/arch/um/drivers/ssl.h~uml-remove-useless-comments
+++ a/arch/um/drivers/ssl.h
@@ -11,13 +11,3 @@ extern void ssl_receive_char(int line, c
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/stdio_console.h~uml-remove-useless-comments arch/um/drivers/stdio_console.h
--- a/arch/um/drivers/stdio_console.h~uml-remove-useless-comments
+++ a/arch/um/drivers/stdio_console.h
@@ -9,13 +9,3 @@
 extern void save_console_flags(void);
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/drivers/xterm.h~uml-remove-useless-comments arch/um/drivers/xterm.h
--- a/arch/um/drivers/xterm.h~uml-remove-useless-comments
+++ a/arch/um/drivers/xterm.h
@@ -10,13 +10,3 @@ extern int xterm_fd(int socket, int *pid
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/asm/irq_vectors.h~uml-remove-useless-comments arch/um/include/asm/irq_vectors.h
--- a/arch/um/include/asm/irq_vectors.h~uml-remove-useless-comments
+++ a/arch/um/include/asm/irq_vectors.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/asm/mmu.h~uml-remove-useless-comments arch/um/include/asm/mmu.h
--- a/arch/um/include/asm/mmu.h~uml-remove-useless-comments
+++ a/arch/um/include/asm/mmu.h
@@ -10,13 +10,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/asm/pda.h~uml-remove-useless-comments arch/um/include/asm/pda.h
--- a/arch/um/include/asm/pda.h~uml-remove-useless-comments
+++ a/arch/um/include/asm/pda.h
@@ -19,13 +19,3 @@ extern struct foo me;
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/asm/pgalloc.h~uml-remove-useless-comments arch/um/include/asm/pgalloc.h
--- a/arch/um/include/asm/pgalloc.h~uml-remove-useless-comments
+++ a/arch/um/include/asm/pgalloc.h
@@ -60,13 +60,3 @@ static inline void pmd_free(struct mm_st
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/asm/pgtable-3level.h~uml-remove-useless-comments arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~uml-remove-useless-comments
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -134,13 +134,3 @@ static inline pmd_t pfn_pmd(pfn_t page_n
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/shared/frame_kern.h~uml-remove-useless-comments arch/um/include/shared/frame_kern.h
--- a/arch/um/include/shared/frame_kern.h~uml-remove-useless-comments
+++ a/arch/um/include/shared/frame_kern.h
@@ -20,13 +20,3 @@ extern int setup_signal_stack_si(unsigne
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/shared/initrd.h~uml-remove-useless-comments arch/um/include/shared/initrd.h
--- a/arch/um/include/shared/initrd.h~uml-remove-useless-comments
+++ a/arch/um/include/shared/initrd.h
@@ -10,13 +10,3 @@ extern int load_initrd(char *filename, v
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/shared/irq_kern.h~uml-remove-useless-comments arch/um/include/shared/irq_kern.h
--- a/arch/um/include/shared/irq_kern.h~uml-remove-useless-comments
+++ a/arch/um/include/shared/irq_kern.h
@@ -16,13 +16,3 @@ extern int um_request_irq(unsigned int i
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/shared/mem_kern.h~uml-remove-useless-comments arch/um/include/shared/mem_kern.h
--- a/arch/um/include/shared/mem_kern.h~uml-remove-useless-comments
+++ a/arch/um/include/shared/mem_kern.h
@@ -18,13 +18,3 @@ extern void register_remapper(struct rem
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/include/shared/ubd_user.h~uml-remove-useless-comments arch/um/include/shared/ubd_user.h
--- a/arch/um/include/shared/ubd_user.h~uml-remove-useless-comments
+++ a/arch/um/include/shared/ubd_user.h
@@ -14,13 +14,3 @@ extern int kernel_fd;
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/kernel/config.c.in~uml-remove-useless-comments arch/um/kernel/config.c.in
--- a/arch/um/kernel/config.c.in~uml-remove-useless-comments
+++ a/arch/um/kernel/config.c.in
@@ -24,13 +24,3 @@ __uml_setup("--showconfig", print_config
 "    Prints the config file that this UML binary was generated from.\n\n"
 );
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-i386/asm/archparam.h~uml-remove-useless-comments arch/um/sys-i386/asm/archparam.h
--- a/arch/um/sys-i386/asm/archparam.h~uml-remove-useless-comments
+++ a/arch/um/sys-i386/asm/archparam.h
@@ -14,13 +14,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-i386/shared/sysdep/checksum.h~uml-remove-useless-comments arch/um/sys-i386/shared/sysdep/checksum.h
--- a/arch/um/sys-i386/shared/sysdep/checksum.h~uml-remove-useless-comments
+++ a/arch/um/sys-i386/shared/sysdep/checksum.h
@@ -199,13 +199,3 @@ static __inline__ __wsum csum_and_copy_t
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ia64/sysdep/ptrace.h~uml-remove-useless-comments arch/um/sys-ia64/sysdep/ptrace.h
--- a/arch/um/sys-ia64/sysdep/ptrace.h~uml-remove-useless-comments
+++ a/arch/um/sys-ia64/sysdep/ptrace.h
@@ -14,13 +14,3 @@ struct sys_pt_regs {
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ia64/sysdep/sigcontext.h~uml-remove-useless-comments arch/um/sys-ia64/sysdep/sigcontext.h
--- a/arch/um/sys-ia64/sysdep/sigcontext.h~uml-remove-useless-comments
+++ a/arch/um/sys-ia64/sysdep/sigcontext.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ia64/sysdep/syscalls.h~uml-remove-useless-comments arch/um/sys-ia64/sysdep/syscalls.h
--- a/arch/um/sys-ia64/sysdep/syscalls.h~uml-remove-useless-comments
+++ a/arch/um/sys-ia64/sysdep/syscalls.h
@@ -8,13 +8,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/miscthings.c~uml-remove-useless-comments arch/um/sys-ppc/miscthings.c
--- a/arch/um/sys-ppc/miscthings.c~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/miscthings.c
@@ -40,14 +40,3 @@ void shove_aux_table(unsigned long sp)
 }
 /* END stuff taken from arch/ppc/kernel/process.c */
 
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/ptrace.c~uml-remove-useless-comments arch/um/sys-ppc/ptrace.c
--- a/arch/um/sys-ppc/ptrace.c~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/ptrace.c
@@ -56,13 +56,3 @@ int peek_user(struct task_struct *child,
 	return put_user(tmp, (unsigned long *) data);
 }
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/ptrace_user.c~uml-remove-useless-comments arch/um/sys-ppc/ptrace_user.c
--- a/arch/um/sys-ppc/ptrace_user.c~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/ptrace_user.c
@@ -27,13 +27,3 @@ int ptrace_setregs(long pid, unsigned lo
     }
     return 0;
 }
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/shared/sysdep/ptrace.h~uml-remove-useless-comments arch/um/sys-ppc/shared/sysdep/ptrace.h
--- a/arch/um/sys-ppc/shared/sysdep/ptrace.h~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/shared/sysdep/ptrace.h
@@ -91,13 +91,3 @@ extern void shove_aux_table(unsigned lon
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/shared/sysdep/sigcontext.h~uml-remove-useless-comments arch/um/sys-ppc/shared/sysdep/sigcontext.h
--- a/arch/um/sys-ppc/shared/sysdep/sigcontext.h~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/shared/sysdep/sigcontext.h
@@ -50,13 +50,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/shared/sysdep/syscalls.h~uml-remove-useless-comments arch/um/sys-ppc/shared/sysdep/syscalls.h
--- a/arch/um/sys-ppc/shared/sysdep/syscalls.h~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/shared/sysdep/syscalls.h
@@ -41,13 +41,3 @@ int old_mmap(unsigned long addr, unsigne
 
 #define LAST_ARCH_SYSCALL __NR_fadvise64
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-ppc/sigcontext.c~uml-remove-useless-comments arch/um/sys-ppc/sigcontext.c
--- a/arch/um/sys-ppc/sigcontext.c~uml-remove-useless-comments
+++ a/arch/um/sys-ppc/sigcontext.c
@@ -2,13 +2,3 @@
 #include "asm/sigcontext.h"
 #include "sysdep/ptrace.h"
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/asm/archparam.h~uml-remove-useless-comments arch/um/sys-x86_64/asm/archparam.h
--- a/arch/um/sys-x86_64/asm/archparam.h~uml-remove-useless-comments
+++ a/arch/um/sys-x86_64/asm/archparam.h
@@ -14,13 +14,3 @@
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/asm/module.h~uml-remove-useless-comments arch/um/sys-x86_64/asm/module.h
--- a/arch/um/sys-x86_64/asm/module.h~uml-remove-useless-comments
+++ a/arch/um/sys-x86_64/asm/module.h
@@ -18,13 +18,3 @@ struct mod_arch_specific
 
 #endif
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
diff -puN arch/um/sys-x86_64/mem.c~uml-remove-useless-comments arch/um/sys-x86_64/mem.c
--- a/arch/um/sys-x86_64/mem.c~uml-remove-useless-comments
+++ a/arch/um/sys-x86_64/mem.c
@@ -14,12 +14,3 @@ unsigned long vm_data_default_flags = __
 unsigned long vm_data_default_flags32 = __VM_DATA_DEFAULT_FLAGS;
 unsigned long vm_force_exec32 = PROT_EXEC;
 
-/* Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch

