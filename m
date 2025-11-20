Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4B92222CC
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763675127; cv=none; b=dkZuAthM/8oDa1mADvJFvCl6uuUgim45o8khJ0WCvOrqJEa+jA6S9EQ7oSCqHs6Se30ooi2KLXMyHa47UsXU7aLmd7VDansyuJIufjS1wrlXds0hM5G24NvEylu6maSRp7Bu4k2xDJmfan324SzZUPbuY2Tc/0897BN1aVDEmG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763675127; c=relaxed/simple;
	bh=lTbLvA8KwX6adwG3EMkDhOXz6e1VErBq48CATDu5pkE=;
	h=Date:To:From:Subject:Message-Id; b=Ti8PwLp9Fd0ObG2eoyszPeUsEyWWj2b7NJoYOy98uZ7Ct+4hqTIrIU733WZi85JQ/+F2VeFG8IvCs+DGDyJ1W8TkVlNrSBkAN4Yjc4Vy2ONWfzjlO/omMlBH2sywOhXLb0lU/AHZTDU1e/cabWMzQGAdfA4w1CLsW2vqVfLtt1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hFiV0FQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hFiV0FQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA4C113D0;
	Thu, 20 Nov 2025 21:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763675127;
	bh=lTbLvA8KwX6adwG3EMkDhOXz6e1VErBq48CATDu5pkE=;
	h=Date:To:From:Subject:From;
	b=hFiV0FQvXSPj5ga+7w4WFaaTnfl+YsQF4q0FJJATY8AmX2YPfsDaI7wGMY9yo9yJz
	 Ed9JKCIN80ROhLXj20rnCvXBaSrg02Mu2/BkH1AL8t10plKNKHgdt2w2CzGRFn9N/o
	 5lMWVbVYtU8MfBS9M3Ks3hXacG5cFK5QuRBAk13k=
Date: Thu, 20 Nov 2025 13:45:26 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch removed from -mm tree
Message-Id: <20251120214527.70DA4C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix grammatical errors
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: fix grammatical errors
Date: Wed, 12 Nov 2025 07:41:12 -0800

Fix a few grammatical errors on DAMON maintainer-profile.

Link: https://lkml.kernel.org/r/20251112154114.66053-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-grammartical-errors
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -27,8 +27,8 @@ maintainer.
 
 Note again the patches for `mm-new tree
 <https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
-subsystem maintainer.  If the patches requires some patches in `damon/next tree
-<https://git.kernel.org/sj/h/damon/next>`_ which not yet merged in mm-new,
+subsystem maintainer.  If the patches require some patches in `damon/next tree
+<https://git.kernel.org/sj/h/damon/next>`_ which have not yet merged in mm-new,
 please make sure the requirement is clearly specified.
 
 Submit checklist addendum
@@ -99,5 +99,5 @@ Schedules and reservation status are ava
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
 There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
-that has the events.  Anyone can subscribe it.  DAMON maintainer will also
-provide periodic reminder to the mailing list (damon@lists.linux.dev).
+that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
+provide periodic reminders to the mailing list (damon@lists.linux.dev).
_

Patches currently in -mm which might be from sj@kernel.org are


