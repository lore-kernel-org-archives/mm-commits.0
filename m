From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 24 Jan 2017 15:17:33 -0800
Message-ID: <20170124151733.e3ed1d56e81c0ec06fc5e6fb@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdAXXRf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 18:17:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

26 fixes, based on a4685d2f58e2230d4e27fb2ee581d7ea35e5d046:

Subject: memory_hotplug: make zone_can_shift() return a boolean value
Subject: mm/huge_memory.c: respect FOLL_FORCE/FOLL_COW for thp
Subject: dax: fix build warnings with FS_DAX and !FS_IOMAP
Subject: kernel/watchdog: prevent false hardlockup on overloaded system
Subject: drivers/memstick/core/memstick.c: avoid -Wnonnull warning
Subject: userfaultfd: fix SIGBUS resulting from false rwsem wakeups
Subject: mm/slub.c: trace free objects at KERN_INFO
Subject: mm: alloc_contig: re-allow CMA to compact FS pages
Subject: proc: add a schedule point in proc_pid_readdir()
Subject: mm, memcg: do not retry precharge charges
Subject: Documentation/filesystems/proc.txt: add VmPin
Subject: radix-tree: fix private list warnings
Subject: mm/mempolicy.c: do not put mempolicy before using its nodemask
Subject: frv: add atomic64_add_unless()
Subject: fbdev: color map copying bounds checking
Subject: kernel/panic.c: add missing \n
Subject: mm, page_alloc: fix check for NULL preferred_zone
Subject: mm, page_alloc: fix fast-path race with cpuset update or removal
Subject: mm, page_alloc: move cpuset seqcount checking to slowpath
Subject: mm, page_alloc: fix premature OOM when racing with cpuset mems update
Subject: frv: add missing atomic64 operations
Subject: romfs: use different way to generate fsid for BLOCK or MTD
Subject: mn10300: fix build error of missing fpu_save()
Subject: mm: do not export ioremap_page_range symbol for external module
Subject: MAINTAINERS: add Dan Streetman to zswap maintainers
Subject: MAINTAINERS: add Dan Streetman to zbud maintainers
