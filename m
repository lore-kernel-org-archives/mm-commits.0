Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB1A921
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467336; cv=none; b=PbP4WsL/UcdWtOVumX4zudVafvTtYWBoL+uLKE007+wvoT6d7vwKCJW/xq8exXmpHUf9H6pOf8vdAbTOV4u6LHRyQJrrAOksIvDYXzcANfLXtnMrCwS5eHa1I8Q0mRHbSDTKvKhSBX4qeh8Bp0fFZvVmaC5ND/RnjMegiBGuGNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467336; c=relaxed/simple;
	bh=Kh3m69Z66vZ+cm+9juI3I9GurBPz6kyTS3q1kZx/4mE=;
	h=Date:To:From:Subject:Message-Id; b=Qxx4GZndxoAJ0uAtsq7bUiVteOZbLwRkJXqmzxUpySXmAUfoANgUiN1jdMgDoLVuUUxqipNt5pR9MXMciXIYAMNsJyFjCm9X9WL/M+fdIKUJETV67O2tm6JRKcwT1+5cuw4y2zORUyCZ5r5Ctelv8I6ajIwB1Bp6NQY4iqwywAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VxtVf65F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VxtVf65F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DEDC2BBFC;
	Sat, 11 May 2024 22:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467336;
	bh=Kh3m69Z66vZ+cm+9juI3I9GurBPz6kyTS3q1kZx/4mE=;
	h=Date:To:From:Subject:From;
	b=VxtVf65FyPhlIt+QsOHyd/VfnqIJxu+3d0wrRzIQzf4IJ1p7NUwYUCS0VVEavhPGx
	 0BReIyV97zEvFMlV0qKNrakqfigMEUu/9RW2/r1/9LdsTgVXCDCAj16M5JEVbT6ct9
	 UQnwiK7L4mrK+z9wECROqKqg4bHaS5JgeVjWtERc=
Date: Sat, 11 May 2024 15:42:15 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch removed from -mm tree
Message-Id: <20240511224216.16DEDC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: change the maintainer's timezone from PST to PT
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: change the maintainer's timezone from PST to PT
Date: Fri, 3 May 2024 11:03:17 -0700

The document says the maintainer is working on only PST.  The maintainer
respects daylight saving system, though.  Update the time zone to PT.

Link: https://lkml.kernel.org/r/20240503180318.72798-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -48,9 +48,9 @@ Review cadence
 --------------
 
 The DAMON maintainer does the work on the usual work hour (09:00 to 17:00,
-Mon-Fri) in PST.  The response to patches will occasionally be slow.  Do not
-hesitate to send a ping if you have not heard back within a week of sending a
-patch.
+Mon-Fri) in PT (Pacific Time).  The response to patches will occasionally be
+slow.  Do not hesitate to send a ping if you have not heard back within a week
+of sending a patch.
 
 
 .. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
_

Patches currently in -mm which might be from sj@kernel.org are


