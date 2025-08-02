Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A443724DCF6
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 19:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754161349; cv=none; b=afUCgO9og6mWQYtHDpKB2G3kwpkP/MljVMzSSuJZtD+eL8DnBrm0IAHAVIErku+4JKqRQ1J+7/PQHg4/E51iJF//axUvP8FKt7JC4XN/XaGWG3rFR8WAnkxNfxZwOfdFGQgcK6MID26iFzJfC+kR0rxtms2QNzzcODOLmXmMVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754161349; c=relaxed/simple;
	bh=tZwoePlhUY/e+YEyqw/q93GQRl9ttrnZsoWpPJ/o0H8=;
	h=Date:To:From:Subject:Message-Id; b=auTiZRfjEtjjW3fXXy6h1zVuXqnPbsywa8HO5dIGOZAehqjNXxB8mhL6UqJVChkOI2018qMUs2GN/Wmpt2XgcujOpvB6+Ro6mNpz1T8OmSKbkK2wcYSNM/e+dBg1kIbH/7KVUTYMUrs0bJTvQgPQi3H9ZfAiF6y8Tjm06OnQRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lM6KnnFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lM6KnnFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1606AC4CEEF;
	Sat,  2 Aug 2025 19:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754161349;
	bh=tZwoePlhUY/e+YEyqw/q93GQRl9ttrnZsoWpPJ/o0H8=;
	h=Date:To:From:Subject:From;
	b=lM6KnnFFbFqTHevD9qpYPboS5wyK5a499B1UsqvygCQ9WvyTBIwlGBBJSNyzwGaLl
	 gWBlFL5WaDIErsHKxPH8UjQvK3cK96xcludxaTGAdrSgoCJOGtF6p5f0del2Kz4wcp
	 CEjT83B8LKtyBRIw/QGuLmFBAVoTEBPPkse4xxf0=
Date: Sat, 02 Aug 2025 12:02:28 -0700
To: mm-commits@vger.kernel.org,jonathan.cameron@huawei.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch removed from -mm tree
Message-Id: <20250802190229.1606AC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: add notifer||notifier to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: scripts/spelling.txt: add notifer||notifier to spelling.txt
Date: Tue, 22 Jul 2025 15:34:31 +0800

This typo was not listed in scripts/spelling.txt, thus it was more
difficult to detect. Add it for convenience.

Link: https://lkml.kernel.org/r/02153C05ED7B49B7+20250722073431.21983-8-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-notifernotifier-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -1099,6 +1099,7 @@ notication||notification
 notications||notifications
 notifcations||notifications
 notifed||notified
+notifer||notifier
 notity||notify
 notfify||notify
 nubmer||number
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


