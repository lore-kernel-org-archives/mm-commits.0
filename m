From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 25 Aug 2017 15:55:20 -0700
Message-ID: <20170825155520.b52d34ebe381e1c3c13ee82c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33744 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935461AbdHYWzV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Aug 2017 18:55:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

6 fixes, based on 90a6cd503982bfd33ce8c70eb49bd2dd33bc6325:

Subject: PM/hibernate: touch NMI watchdog when creating snapshot
Subject: mm, shmem: fix handling /sys/kernel/mm/transparent_hugepage/shmem_enabled
Subject: dax: fix deadlock due to misaligned PMD faults
Subject: mm/madvise.c: fix freeing of locked page with MADV_FREE
Subject: fork: fix incorrect fput of ->exe_file causing use-after-free
Subject: mm/memblock.c: reversed logic in memblock_discard()



