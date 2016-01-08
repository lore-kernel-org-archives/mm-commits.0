From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch removed from
 -mm tree
Date: Fri, 08 Jan 2016 12:33:28 -0800
Message-ID: <56901d18.RI1lqGupso+RDYo4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbcAHUd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 15:33:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: exit with failure for non anonymous thp
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: exit with failure for non anonymous thp

Currently memory_failure() doesn't handle non anonymous thp case, because
we can hardly expect the error handling to be successful, and it can just
hit some corner case which results in BUG_ON or something severe like
that.  This is also a case for soft offline code, so let's make it in the
same way.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff -puN mm/memory-failure.c~mm-soft-offline-exit-with-failure-for-non-anonymous-thp mm/memory-failure.c
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

