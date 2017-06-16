From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 16 Jun 2017 14:02:17 -0700
Message-ID: <20170616140217.04013e01cf2bb8daafa349d8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751103AbdFPVCS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Jun 2017 17:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

5 fixes, based on ab2789b72df3cf7a01e30636ea86cbbf44ba2e99:

Subject: mm/memory-failure.c: use compound_head() flags for huge pages
Subject: swap: cond_resched in swap_cgroup_prepare()
Subject: mm: numa: avoid waiting on freed migrated pages
Subject: userfaultfd: shmem: handle coredumping in handle_userfault()
Subject: mm: correct the comment when reclaimed pages exceed the scanned pages



