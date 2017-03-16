From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 16 Mar 2017 16:40:07 -0700
Message-ID: <20170316164007.698fc8744aa63cabd5bc6df7@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdCQASB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 20:18:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

6 fixes, based on 69eea5a4ab9c705496e912b55a9d312325de19e6:

Subject: z3fold: fix spinlock unlocking in page reclaim
Subject: kasan: add a prototype of task_struct to avoid warning
Subject: mm, x86: fix native_pud_clear build error
Subject: mm: don't warn when vmalloc() fails due to a fatal signal
Subject: mm: add private lock to serialize memory hotplug operations
Subject: drivers core: remove assert_held_device_hotplug()



