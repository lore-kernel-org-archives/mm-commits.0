From: akpm@linux-foundation.org
Subject: + codingstyle-add-networking-specific-block-comment-style.patch added to -mm tree
Date: Wed, 12 Sep 2012 14:12:35 -0700
Message-ID: <20120912211236.91AD8200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52615 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2ILVMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 17:12:39 -0400
Received: by fass10 with SMTP id s10so145844fas.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 14:12:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, apw@canonical.com, bruce.w.allan@intel.com, davem@davemloft.net


The patch titled
     Subject: CodingStyle: add networking specific block comment style
has been added to the -mm tree.  Its filename is
     codingstyle-add-networking-specific-block-comment-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: CodingStyle: add networking specific block comment style

The block comment style in net/ and drivers/net is non-standard.
Document it.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN Documentation/CodingStyle~codingstyle-add-networking-specific-block-comment-style Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-add-networking-specific-block-comment-style
+++ a/Documentation/CodingStyle
@@ -454,6 +454,16 @@ The preferred style for long (multi-line
 	 * with beginning and ending almost-blank lines.
 	 */
 
+For files in net/ and drivers/net/ the preferred style for long (multi-line)
+comments is a little different.
+
+	/* The preferred comment style for files in net/ and drivers/net
+	 * looks like this.
+	 *
+	 * It is nearly the same as the generally preferred comment style,
+	 * but there is no initial almost-blank line.
+	 */
+
 It's also important to comment data, whether they are basic types or derived
 types.  To this end, use just one data declaration per line (no commas for
 multiple data declarations).  This leaves you room for a small comment on each
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-gianfar_ptp-after-renaming.patch
checkpatch-check-utf-8-content-from-a-commit-log-when-its-missing-from-charset.patch
checkpatch-update-suggested-printk-conversions.patch
checkpatch-check-networking-specific-block-comment-style.patch
codingstyle-add-networking-specific-block-comment-style.patch

