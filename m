From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?scripts-deprecated=5Fterms-recommend-denylist-allowlist-inst?=
 =?us-ascii?Q?ead-of-blacklist-whitelist.patch?= added to -mm tree
Date: Wed, 17 Jun 2020 14:32:22 -0700
Message-ID: <20200617213222.OcDiV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgFQVcX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 17:32:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sj38.park@gmail.com, mpe@ellerman.id.au, jslaby@suse.cz, colin.king@canonical.com, sjpark@amazon.de


The patch titled
     Subject: scripts/deprecated_terms: recommend denylist/allowlist instead of blacklist/whitelist
has been added to the -mm tree.  Its filename is
     scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: SeongJae Park <sjpark@amazon.de>
Subject: scripts/deprecated_terms: recommend denylist/allowlist instead of blacklist/whitelist

This commit recommends that patches replace 'blacklist' and 'whitelist'
with 'denylist' and 'allowlist', because the new suggestions are
incontrovertible, doesn't make people hurt, and are more self-explanatory.

Link: http://lkml.kernel.org/r/20200611062550.20113-3-sjpark@amazon.com
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: SeongJae Park <sj38.park@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/deprecated_terms.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/deprecated_terms.txt~scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist
+++ a/scripts/deprecated_terms.txt
@@ -3,3 +3,5 @@
 # The format of each line is:
 # deprecated||suggested
 #
+blacklist||denylist
+whitelist||allowlist
_

Patches currently in -mm which might be from sjpark@amazon.de are

checkpatch-support-deprecated-terms-checking.patch
scripts-deprecated_terms-recommend-denylist-allowlist-instead-of-blacklist-whitelist.patch
