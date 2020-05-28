From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 27 May 2020 22:20:15 -0700
Message-ID: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbgE1FUR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 01:20:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


5 fixes, based on 444fc5cde64330661bf59944c43844e7d4c2ccd8:


    Qian Cai <cai@lca.pw>:
      mm/z3fold: silence kmemleak false positives of slots

    Hugh Dickins <hughd@google.com>:
      mm,thp: stop leaking unreleased file pages

    Konstantin Khlebnikov <khlebnikov@yandex-team.ru>:
      mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

    Alexander Potapenko <glider@google.com>:
      fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

    Arnd Bergmann <arnd@arndb.de>:
      include/asm-generic/topology.h: guard cpumask_of_node() macro argument

 fs/binfmt_elf.c                |    2 +-
 include/asm-generic/topology.h |    2 +-
 include/linux/mm.h             |   19 +++++++++++++++----
 mm/khugepaged.c                |    1 +
 mm/z3fold.c                    |    3 +++
 5 files changed, 21 insertions(+), 6 deletions(-)
