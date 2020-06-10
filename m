From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 =?US-ASCII?Q?scripts-spelling-recommend-blocklist-allowlist-instead-of-b?=
 =?US-ASCII?Q?lacklist-whitelist.patch?= removed from -mm tree
Date: Wed, 10 Jun 2020 14:03:52 -0700
Message-ID: <20200610210352.BkzG7-wrc%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgFJVDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 17:03:54 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org, sjpark@amazon.de


The patch titled
     Subject: scripts/spelling: recommend blocklist/allowlist instead of blacklist/whitelist
has been removed from the -mm tree.  Its filename was
     scripts-spelling-recommend-blocklist-allowlist-instead-of-blacklist-whitelist.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: scripts/spelling: recommend blocklist/allowlist instead of blacklist/whitelist

This commit recommends the patches to replace 'blacklist' and 'whitelist'
with the 'blocklist' and 'allowlist', because the new suggestions are
incontrovertible, doesn't make people hurt, and more self-explanatory.

Link: http://lkml.kernel.org/r/20200609122549.26304-1-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/spelling.txt~scripts-spelling-recommend-blocklist-allowlist-instead-of-blacklist-whitelist
+++ a/scripts/spelling.txt
@@ -231,6 +231,7 @@ beter||better
 betweeen||between
 bianries||binaries
 bitmast||bitmask
+blacklist||blocklist
 boardcast||broadcast
 borad||board
 boundry||boundary
@@ -1504,6 +1505,7 @@ whcih||which
 whenver||whenever
 wheter||whether
 whe||when
+whitelist||allowlist
 wierd||weird
 wiil||will
 wirte||write
_

Patches currently in -mm which might be from sjpark@amazon.de are

scripts-spelling-add-a-few-more-typos.patch
