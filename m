Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517C0356A12
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338709; cv=none; b=Ypl30xRucP9ytb6GV+8EUgvhOvnrJB6QbQjPujIzPrt1DD1jSsii83SCKySe2Ml6u70n4dvHQu+6eTOB6tX2fLymJThgQvv81Chkugt9KgLhR0V/jOTZlAz2SH0f/GS5Ha/iOxTFt5t+/njL1WMtV+HjmMBbU4d1wPdeHiZPsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338709; c=relaxed/simple;
	bh=iYGdFfdZZGZzrrvD5pFIkmQIkLO/3zLE4+PC/2wSAVM=;
	h=Date:To:From:Subject:Message-Id; b=pb4bKgHOqHt7dgUYJWXD5VpXpzUXgqtarOk6KGheEayIIMdeci6az/d6zS5wi/KnqI9DkkHRtFr4xunBnMBwui7c6J8LcTIcZmBKDJL4dtjwypn7IJRkoIyO8xFrEv1k1gkSLZC16Bj5EBzxZRq7mdnG3xSFWq2ZlXU023BzoHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EmnYT60g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmnYT60g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8231F0089B;
	Wed,  7 Oct 2026 02:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338707;
	bh=2I8A2d5vsWY9lwHegj2JagzPoCyIf6epjRNcEF/Lcuo=;
	h=Date:To:From:Subject;
	b=EmnYT60gMyy6SAr+veVe4/mAcWI3LQQQm2UR4qY1KeDoNJhvdcp7bzbkLQmaPoupF
	 jEjMNoNfaOGOq3uWySYKrAH29ucN2O2NkIacRSPuPIqnWbLO01xqRymNXoLmkEgBU5
	 o+Gfqz3ZC236uX6XpgPxu4kQzZ39f9McRHGMnY0Y=
Date: Tue, 06 Oct 2026 19:05:07 -0700
To: mm-commits@vger.kernel.org,andrey.golovko@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-address-for-andrey-golovko.patch removed from -mm tree
Message-Id: <20261007020507.CC8231F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Andrey Golovko
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-andrey-golovko.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrey Golovko <andrey.golovko@gmail.com>
Subject: mailmap: update email address for Andrey Golovko
Date: Sat, 12 Sep 2026 19:26:30 +0300

Patches sent from andrey.golovko@gmail.com carry the authorship of my
commits, but some of the tags I gave on other people's patches use
andrey@golovko.me.  Map the second address onto the first so the two do
not look like two different contributors.

Link: https://lore.kernel.org/20260912162630.7731-1-andrey.golovko@gmail.com
Signed-off-by: Andrey Golovko <andrey.golovko@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-andrey-golovko
+++ a/.mailmap
@@ -92,6 +92,7 @@ Andrew Morton <akpm@linux-foundation.org
 Andrew Murray <amurray@thegoodpenguin.co.uk> <amurray@embedded-bits.co.uk>
 Andrew Murray <amurray@thegoodpenguin.co.uk> <andrew.murray@arm.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andrey Golovko <andrey.golovko@gmail.com> <andrey@golovko.me>
 Andrey Konovalov <andreyknvl@gmail.com> <andreyknvl@google.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <a.ryabinin@samsung.com>
 Andrey Ryabinin <ryabinin.a.a@gmail.com> <aryabinin@virtuozzo.com>
_

Patches currently in -mm which might be from andrey.golovko@gmail.com are


