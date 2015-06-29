From: akpm@linux-foundation.org
Subject: [merged] checkpatch-remove-local-from-codespell-path.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:45 -0700
Message-ID: <5591af2d.688O0YJCiNq7obGL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbbF2Usp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxim.uvarov@linaro.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove local from codespell path
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-local-from-codespell-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxim Uvarov <maxim.uvarov@linaro.org>
Subject: checkpatch: remove local from codespell path

local is typically used for manually installed apps.
For apps installed from distro the right path is /usr/share.

Signed-off-by: Maxim Uvarov <maxim.uvarov@linaro.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-local-from-codespell-path scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-local-from-codespell-path
+++ a/scripts/checkpatch.pl
@@ -50,7 +50,7 @@ my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
-my $codespellfile = "/usr/local/share/codespell/dictionary.txt";
+my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $color = 1;
 
 sub help {
@@ -95,7 +95,7 @@ Options:
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
   --codespell                Use the codespell dictionary for spelling/typos
-                             (default:/usr/local/share/codespell/dictionary.txt)
+                             (default:/usr/share/codespell/dictionary.txt)
   --codespellfile            Use this codespell dictionary
   --color                    Use colors when output is STDOUT (default: on)
   -h, --help, --version      display this help and exit
_

Patches currently in -mm which might be from maxim.uvarov@linaro.org are

origin.patch

