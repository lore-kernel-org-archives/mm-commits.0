Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79261D6AA
	for <mm-commits@vger.kernel.org>; Wed, 28 Jan 2026 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769624784; cv=none; b=ZWVbYPyUkQ5/yNChbCv+nzYdjyuQEveZPvJJaywyxiL7HmfYlWcK7lszpWLgavOlhCSJIOXaLMCyKK9h8A7PpovKIb6nZvDp17spJj/x4ww3w9zr8COEozCgj1aq78p39hI3JP9oF+qOaoklhFod4reT2DlvXVNhwb4a2PexKg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769624784; c=relaxed/simple;
	bh=UXm3acI9DV8DNHcbOdShSPARpeKuOiaHAYGV7KN2INk=;
	h=Date:To:From:Subject:Message-Id; b=OOZzAcWT7pwMEcAMLxzyYcVqI/ZFHLu3FZUxNoL09L3OQKCsx1X7enbhh8pJFWQK7CnB1h0ii1Vgn2ddlxJiSmXiC4aPvigR3warlpLRZTkZKAVUJMWfSN6YygvYRmGw9XsFZBqxa0Ka38gU9Rdjsqm3dpDw2HAsOLnswy85i9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gutTAIEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gutTAIEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF52C4CEF1;
	Wed, 28 Jan 2026 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769624784;
	bh=UXm3acI9DV8DNHcbOdShSPARpeKuOiaHAYGV7KN2INk=;
	h=Date:To:From:Subject:From;
	b=gutTAIEuQ+ukOriqK5iDLs1Dgp81+zZQ6rgswSsDd9+RecdKDKIzzRypFh5WNXAXx
	 HwnQT7W37Q1wC/qL6xZoyfcn99YkHKS735z9tWvrWizERF4CBYBN0q5O4peK0nH9ra
	 NcYTt6cs3WScyvuyEqABCJJve3ol/7BryGSA+NgE=
Date: Wed, 28 Jan 2026 10:26:23 -0800
To: mm-commits@vger.kernel.org,aleksandr.mikhalitsyn@futurfusion.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-alexander-mikhalitsyns-emails.patch added to mm-hotfixes-unstable branch
Message-Id: <20260128182624.5EF52C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: update Alexander Mikhalitsyn's emails
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-alexander-mikhalitsyns-emails.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-alexander-mikhalitsyns-emails.patch

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
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Subject: mailmap: update Alexander Mikhalitsyn's emails
Date: Wed, 28 Jan 2026 18:39:15 +0100

Link: https://lkml.kernel.org/r/20260128173915.162309-1-alexander@mihalicyn.com
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-alexander-mikhalitsyns-emails
+++ a/.mailmap
@@ -33,6 +33,7 @@ Alexander Lobakin <alobakin@pm.me> <alob
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@futurfusion.io>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin.ext@nsn.com>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@gmx.de>
 Alexander Sverdlin <alexander.sverdlin@gmail.com> <alexander.sverdlin@nokia.com>
_

Patches currently in -mm which might be from aleksandr.mikhalitsyn@futurfusion.io are

mailmap-update-alexander-mikhalitsyns-emails.patch

