Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5EF296BCB
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 18:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782672855; cv=none; b=StgOlzi3fVoeVIJBFxFM+wisHOhaj6ytcvS0JYCyofr/5Punt+/wM4UEw5eRjwcjvGTTWq4/90vSpAsalW+gx+o9u4d0Ek0XyhRPy048quHkWZrxr+3inSNtB+Ohpilxin2Of5cTWl46nzlbDYMB8gNSIola28YyTyYaHeqKBnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782672855; c=relaxed/simple;
	bh=iqDhI47KVBEhPTAQLFsll2QqMljMzvNkuHrMlukH1fo=;
	h=Date:To:From:Subject:Message-Id; b=BDvh6zSFgjEUrWMRf0iFO8GJL+2H5g4bo+4cKn0RZyczXtLNdbUclmS9T1raKYY9NvbtmDxkqPt5DKaJm77apeHaciDmxQPiJtpYDD5Lu1gKYbu/GrbKRL53sv6tcRept7kRd44t6X8cM3qL5ckT9Cj5pEI7S2nKKvJ3gvykqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UEqglCVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UEqglCVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBC51F000E9;
	Sun, 28 Jun 2026 18:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782672853;
	bh=hgzlS0ytnsRWbLX9POE6+/NiPBFQAotxnT9H9lqvemg=;
	h=Date:To:From:Subject;
	b=UEqglCVxfQzlGkzpR/ttC/Ny0QB7pYWPUQKT6JeTOsf8wFBlXUGKAkC5OGYW/n0Xc
	 GPL3/+YskCGRxrLb9fu0NAt5nV/rtSX52qLpRrLHWTP5Cys3312XV/h8ZORUW9i36G
	 Kmoy2xyy3cozll/m97RgQxoib9toxpur+zEqIqWE=
Date: Sun, 28 Jun 2026 11:54:12 -0700
To: mm-commits@vger.kernel.org,kuba@kernel.org,radu@rendec.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-radu-rendec.patch added to mm-hotfixes-unstable branch
Message-Id: <20260628185413.0EBC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entries for Radu Rendec
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-radu-rendec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-radu-rendec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Radu Rendec <radu@rendec.net>
Subject: mailmap: add entries for Radu Rendec
Date: Sun, 28 Jun 2026 11:02:03 -0400

I have used multiple email addresses for my kernel contributions, and some
of them are no longer active.  Add all to .mailmap for clarity.

Link: https://lore.kernel.org/20260628150203.4105796-1-radu@rendec.net
Signed-off-by: Radu Rendec <radu@rendec.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-radu-rendec
+++ a/.mailmap
@@ -707,6 +707,10 @@ Qi Zheng <qi.zheng@linux.dev> <zhengqi.a
 Quentin Monnet <qmo@kernel.org> <quentin.monnet@netronome.com>
 Quentin Monnet <qmo@kernel.org> <quentin@isovalent.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
+Radu Rendec <radu@rendec.net> <radu.rendec@ines.ro>
+Radu Rendec <radu@rendec.net> <rrendec@arista.com>
+Radu Rendec <radu@rendec.net> <radu.rendec@gmail.com>
+Radu Rendec <radu@rendec.net> <rrendec@redhat.com>
 Rae Moar <raemoar63@gmail.com> <rmoar@google.com>
 Rafael J. Wysocki <rjw@rjwysocki.net> <rjw@sisk.pl>
 Rajeev Nandan <quic_rajeevny@quicinc.com> <rajeevny@codeaurora.org>
_

Patches currently in -mm which might be from radu@rendec.net are

mailmap-add-entries-for-radu-rendec.patch

