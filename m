From: akpm@linux-foundation.org
Subject: [merged] codingstyle-add-networking-specific-block-comment-style.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:16:13 -0700
Message-ID: <20121005201613.AB0C5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43213 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2JEUQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:16:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so236711vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:16:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, bruce.w.allan@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: CodingStyle: add networking specific block comment style
has been removed from the -mm tree.  Its filename was
     codingstyle-add-networking-specific-block-comment-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

