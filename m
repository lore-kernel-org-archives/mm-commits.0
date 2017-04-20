From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 20 Apr 2017 14:37:33 -0700
Message-ID: <20170420143733.6f16ee9a9c236ad396d28a8d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971116AbdDTVhf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Apr 2017 17:37:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

2 fixes, based on f61143c45077df4fa78e2f1ba455a00bbe1d5b8c:

Subject: Revert "mm, page_alloc: only use per-cpu allocator for irq-safe requests"
Subject: mm: prevent NR_ISOLATE_* stats from going negative


