From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 31 Aug 2017 16:15:08 -0700
Message-ID: <20170831161508.fb8db012c849640683a5a626@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52840 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbdHaXPJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Aug 2017 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

6 fixes, baed on 42ff72cf27027fa28dd79acabe01d9196f1480a7:

Subject: mm,page_alloc: don't call __node_reclaim() with oom_lock held.
Subject: kernel/kthread.c: kthread_worker: don't hog the cpu
Subject: mm, uprobes: fix multiple free of ->uprobes_state.xol_area
Subject: mm, madvise: ensure poisoned pages are removed from per-cpu lists
Subject: include/linux/compiler.h: don't perform compiletime_assert with -O0
Subject: scripts/dtc: fix '%zx' warning



