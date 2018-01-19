From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 18 Jan 2018 16:33:40 -0800
Message-ID: <20180118163340.4e6bfdcaab4cc3308480188b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754426AbeASAdm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 19:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

6 fixes, based on dda3e15231b35840fe6f0973f803cc70ddb86281:

Subject: mm/memory.c: release locked page in do_swap_page()
Subject: mm/page_owner.c: remove drain_all_pages from init_early_allocated_pages
Subject: scripts/decodecode: fix decoding for AArch64 (arm64) instructions
Subject: scripts/gdb/linux/tasks.py: fix get_thread_info
Subject: proc: fix coredump vs read /proc/*/stat race
Subject: sparse doesn't support struct randomization

