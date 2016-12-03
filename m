From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 2 Dec 2016 17:26:33 -0800
Message-ID: <20161202172633.dab07ecb4a639f38b68f0b28@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34590 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756246AbcLCB0M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 20:26:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

2 fixes, based on 8dc0f265d39a3933f4c1f846c7c694f12a2ab88a:

Subject: mm: workingset: fix NULL ptr in count_shadow_nodes
Subject: mm, vmscan: add cond_resched() into shrink_node_memcg()

