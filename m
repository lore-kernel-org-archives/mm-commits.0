From: akpm@linux-foundation.org
Subject: + checkpatch-add-another-old-address-for-the-fsf.patch added to
 -mm tree
Date: Tue, 31 Jan 2017 16:23:54 -0800
Message-ID: <58912a9a.oVd3hvdciKa584K2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38258 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdBAAYF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 19:24:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add another old address for the FSF
has been added to the -mm tree.  Its filename is
     checkpatch-add-another-old-address-for-the-fsf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-another-old-address-for-the-fsf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-another-old-address-for-the-fsf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: checkpatch: add another old address for the FSF

We still have a lot of old addresses for the FSF in the kernel.

willy@harry:~/kernel/idr$ git grep '675 Mass' |wc -l
1502
willy@harry:~/kernel/idr$ git grep '59 Temple' |wc -l
2825
willy@harry:~/kernel/idr$ git grep '51 Franklin' |wc -l
2020

Let's discourage adding the oldest one too.

Link: http://lkml.kernel.org/r/20170128173052.GA23532@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-another-old-address-for-the-fsf scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-another-old-address-for-the-fsf
+++ a/scripts/checkpatch.pl
@@ -2703,6 +2703,7 @@ sub process {
 
 # Check for FSF mailing addresses.
 		if ($rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b675\s+Mass\s+Ave/i ||
 		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
 		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

find_bit-micro-optimise-find_next__bit.patch
find_bit-micro-optimise-find_next__bit-v2.patch
checkpatch-add-another-old-address-for-the-fsf.patch

