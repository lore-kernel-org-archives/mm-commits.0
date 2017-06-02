From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 2 Jun 2017 14:45:24 -0700
Message-ID: <20170602144524.cc26aae3833c40c3e003e34f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51166 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdFBVpZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

15 fixes, baed on c531577bcdac51225f50033e0c89644873f4dc6d:

Subject: ksm: prevent crash after write_protect_page fails
Subject: include/linux/gfp.h: fix  ___GFP_NOLOCKDEP value
Subject: frv: declare jiffies to be located in the .data section
Subject: mm: clarify why we want kmalloc before falling backto vmallock
Subject: initramfs: fix disabling of initramfs (and its compression)
Subject: slub/memcg: cure the brainless abuse of sysfs attributes
Subject: pcmcia: remove left-over %Z format
Subject: mm/page_alloc.c: make sure OOM victim can try allocations with no watermarks once
Subject: mm: avoid spurious 'bad pmd' warning messages
Subject: dax: fix race between colliding PMD & PTE entries
Subject: mm/migrate: fix refcount handling when !hugepage_migration_supported()
Subject: mlock: fix mlock count can not decrease in race condition
Subject: mm/hugetlb: report -EHWPOISON not -EFAULT when FOLL_HWPOISON is specified
Subject: mm: consider memblock reservations for deferred memory initialization sizing
Subject: scripts/gdb: make lx-dmesg command work (reliably)
