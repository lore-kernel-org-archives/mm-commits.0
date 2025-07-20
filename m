Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8993595E
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978409; cv=none; b=YFiTybmzl/slaPadaVFqqyE9IoFFVtVQSHuQy9DCf1ZUPU09sXrSckDwaowkzLKSzOvftObDD/mwdZNtVelo53hN17Jq+qscOLUtCp45vzOCFbmxWetTOvz9je1MnWU5V0j9l78LP86qGB3oG1/Igc1fBC0WRzHTcAO4zL4EKUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978409; c=relaxed/simple;
	bh=OYD8L94MVXwNfHrX6Q9GiRXdHy5f6O7mZtt5tkPcKCY=;
	h=Date:To:From:Subject:Message-Id; b=YvbaKi/IQwYKihvuxiboCkIyqgCr5nrB9YfNSPONRivZZ81K+HroJ7dFX1dOYxDOb4498IgZl6a46idSF4g8tQTedEL+KOVDQcUfSyWBop5jHkf5G5j1N9s0nr/ZetKsDPAloYyAonQongr1cVbUV2l3DFhdcQD10QxVnhAYV1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E9mZ6yYf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E9mZ6yYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6356DC4AF09;
	Sun, 20 Jul 2025 02:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978409;
	bh=OYD8L94MVXwNfHrX6Q9GiRXdHy5f6O7mZtt5tkPcKCY=;
	h=Date:To:From:Subject:From;
	b=E9mZ6yYfK+1eNNU2hvir3ko+o/rwWwqkh8FBM5UH5QTQIQptS4HBFDjQZCKBTsDId
	 DZ8LBEc81Z4eoNxaVaDsZNgQs3pMqWiStJIEYVwfhoHhVAHDZtEmPaK0TLX5didFjT
	 1nHQabGNKddexlbyMRiQFFEkF4W6xRJMQkCW9ZO4=
Date: Sat, 19 Jul 2025 19:26:48 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-senozhatsky.patch removed from -mm tree
Message-Id: <20250720022649.6356DC4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Senozhatsky
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-senozhatsky.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mailmap: add entry for Senozhatsky
Date: Mon, 7 Jul 2025 16:52:13 +0900

Consolidate and map all addresses to a single one.

Link: https://lkml.kernel.org/r/20250707075243.858895-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-senozhatsky
+++ a/.mailmap
@@ -693,6 +693,10 @@ Sedat Dilek <sedat.dilek@gmail.com> <sed
 Senthilkumar N L <quic_snlakshm@quicinc.com> <snlakshm@codeaurora.org>
 Serge Hallyn <sergeh@kernel.org> <serge.hallyn@canonical.com>
 Serge Hallyn <sergeh@kernel.org> <serue@us.ibm.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky.work@gmail.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@gmail.com>
+Sergey Senozhatsky <senozhatsky@chromium.org> <sergey.senozhatsky@mail.by>
+Sergey Senozhatsky <senozhatsky@chromium.org> <senozhatsky@google.com>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
 Shannon Nelson <sln@onemain.com> <shannon.nelson@amd.com>
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


