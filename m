From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 23 Jun 2017 15:08:29 -0700
Message-ID: <20170623150829.cc0c3cb5f20b244c5b8fd5a2@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32972 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754179AbdFWWIf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 23 Jun 2017 18:08:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

8 fixes, based on a38371cba67539ce6a5d5324db34bc2ddaf66cc1:

Subject: mm, thp: remove cond_resched from __collapse_huge_page_copy
Subject: mm/vmalloc.c: huge-vmap: fail gracefully on unexpected huge vmap mappings
Subject: autofs: sanity check status reported with AUTOFS_DEV_IOCTL_FAIL
Subject: fs/dax.c: fix inefficiency in dax_writeback_mapping_range()
Subject: lib/cmdline.c: fix get_options() overflow while parsing ranges
Subject: slub: make sysfs file removal asynchronous
Subject: ocfs2: fix deadlock caused by recursive locking in xattr
Subject: fs/exec.c: account for argv/envp pointers

