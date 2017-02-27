From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Mon, 27 Feb 2017 14:25:44 -0800
Message-ID: <20170227142544.36f18e8c850d54f5387513ac@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdB0W0n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


- a few MM remainders

- misc things

- autofs updates

- signals

- affs updates

- ipc

- nilfs2

- spelling.txt updates

78 patches, based on e5d56efc97f8240d0b5d66c03949382b6d7e5570:

Subject: mm,fs,dax: mark dax_iomap_pmd_fault as const
Subject: zswap: allow initialization at boot without pool
Subject: zswap: clear compressor or zpool param if invalid at init
Subject: zswap: don't param_set_charp while holding spinlock
Subject: kprobes: move kprobe declarations to asm-generic/kprobes.h
Subject: autofs: remove wrong comment
Subject: autofs: fix typo in Documentation
Subject: autofs: fix wrong ioctl documentation regarding devid
Subject: autofs: update ioctl documentation regarding struct autofs_dev_ioctl
Subject: autofs: add command enum/macros for root-dir ioctls
Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition
Subject: autofs: take more care to not update last_used on path walk
Subject: hfsplus: atomically read inode size
Subject: fs/reiserfs: atomically read inode size
Subject: sigaltstack: support SS_AUTODISARM for CONFIG_COMPAT
Subject: tools/testing/selftests/sigaltstack/sas.c: improve output of sigaltstack testcase
Subject: /proc/kcore: update physical address for kcore ram and text
Subject: rapidio: use get_user_pages_unlocked()
Subject: include/linux/pid.h: use for_each_thread() in do_each_pid_thread()
Subject: fs,eventpoll: Don't test for bitfield with stack value
Subject: fs/affs: remove reference to affs_parent_ino()
Subject: fs/affs: add validation block function
Subject: fs/affs: make affs exportable
Subject: fs/affs: use octal for permissions
Subject: fs/affs: add prefix to some functions
Subject: fs/affs/namei.c: forward declarations clean-up
Subject: fs/affs: make export work with cold dcache
Subject: config: android-recommended: disable aio support
Subject: config: android-base: enable hardened usercopy and kernel ASLR
Subject: lib/fonts/Kconfig: keep non-Sparc fonts listed together
Subject: initramfs: finish fput() before accessing any binary from initramfs
Subject: ipc/sem.c: avoid using spin_unlock_wait()
Subject: ipc/sem: add hysteresis
Subject: ipc/mqueue: add missing sparse annotation
Subject: ipc/shm: Fix shmat mmap nil-page protection
Subject: scatterlist: reorder compound boolean expression
Subject: scatterlist: do not disable IRQs in sg_copy_buffer
Subject: fs: add i_blocksize()
Subject: nilfs2: use nilfs_btree_node_size()
Subject: nilfs2: use i_blocksize()
Subject: scripts/spelling.txt: add "swith" pattern and fix typo instances
Subject: scripts/spelling.txt: add "swithc" pattern and fix typo instances
Subject: scripts/spelling.txt: add "an user" pattern and fix typo instances
Subject: scripts/spelling.txt: add "an union" pattern and fix typo instances
Subject: scripts/spelling.txt: add "an one" pattern and fix typo instances
Subject: scripts/spelling.txt: add "partiton" pattern and fix typo instances
Subject: scripts/spelling.txt: add "aligment" pattern and fix typo instances
Subject: scripts/spelling.txt: add "algined" pattern and fix typo instances
Subject: scripts/spelling.txt: add "efective" pattern and fix typo instances
Subject: scripts/spelling.txt: add "varible" pattern and fix typo instances
Subject: scripts/spelling.txt: add "embeded" pattern and fix typo instances
Subject: scripts/spelling.txt: add "againt" pattern and fix typo instances
Subject: scripts/spelling.txt: add "neded" pattern and fix typo instances
Subject: scripts/spelling.txt: add "unneded" pattern and fix typo instances
Subject: scripts/spelling.txt: add "intialization" pattern and fix typo instances
Subject: scripts/spelling.txt: add "initialiazation" pattern and fix typo instances
Subject: scripts/spelling.txt: add "comsume(r)" pattern and fix typo instances
Subject: scripts/spelling.txt: add "overrided" pattern and fix typo instances
Subject: scripts/spelling.txt: add "configuartion" pattern and fix typo instances
Subject: scripts/spelling.txt: add "applys" pattern and fix typo instances
Subject: scripts/spelling.txt: add "explictely" pattern and fix typo instances
Subject: scripts/spelling.txt: add "omited" pattern and fix typo instances
Subject: scripts/spelling.txt: add "disassocation" pattern and fix typo instances
Subject: scripts/spelling.txt: add "deintialize(d)" pattern and fix typo instances
Subject: scripts/spelling.txt: add "overwritting" pattern and fix typo instances
Subject: scripts/spelling.txt: add "overwriten" pattern and fix typo instances
Subject: scripts/spelling.txt: add "therfore" pattern and fix typo instances
Subject: scripts/spelling.txt: add "followings" pattern and fix typo instances
Subject: scripts/spelling.txt: add some typo-words
Subject: lib/vsprintf.c: remove %Z support
Subject: checkpatch: warn when formats use %Z and suggest %z
Subject: mm: add new mmgrab() helper
Subject: mm: add new mmget() helper
Subject: mm: use mmget_not_zero() helper
Subject: mm: clarify mm_struct.mm_{users,count} documentation
Subject: hfs: atomically read inode size
Subject: mm: add arch-independent testcases for RODATA
Subject: mm, x86: fix HIGHMEM64 && PARAVIRT build config for native_pud_clear()

