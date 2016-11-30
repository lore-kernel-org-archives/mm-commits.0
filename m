From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 30 Nov 2016 15:53:52 -0800
Message-ID: <20161130155352.ca24ed7ae8b69d5d9538cadb@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43242 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754672AbcK3Xxg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 18:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

7 fixes, based on ded6e842cf499ef04b0d611d92b859d5b846c497:

Subject: mm, thp: propagation of conditional compilation in khugepaged.c
Subject: thp: fix corner case of munlock() of PTE-mapped THPs
Subject: zram: fix unbalanced idr management at hot removal
Subject: lib/debugobjects: export for use in modules
Subject: kasan: update kasan_global for gcc 7
Subject: kasan: support use-after-scope detection
Subject: mm: fix false-positive WARN_ON() in truncate/invalidate for hugetlb


