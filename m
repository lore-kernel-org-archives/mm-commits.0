From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 13 Sep 2017 16:28:04 -0700
Message-ID: <20170913162804.96b56731baaa198fcf060b10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdIMX2F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 19:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


A few leftovers.  Now with fixed up locale stuff, fingers crossed.

9 patches, based on 46c1e79fee417f151547aa46fae04ab06cb666f4:

Subject: idr: remove WARN_ON_ONCE() when trying to replace negative ID
Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4
Subject: procfs: remove unused variable
Subject: lib/test_bitmap.c: use ULL suffix for 64-bit constants
Subject: fscache: fix fscache_objlist_show format processing
Subject: IB/mlx4: fix sprintf format warning
Subject: mm: treewide: remove GFP_TEMPORARY allocation flag
Subject: arm64: stacktrace: avoid listing stacktrace functions in stacktrace
Subject: mm, page_owner: skip unnecessary stack_trace entries



