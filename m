Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4E4185B58
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855631; cv=none; b=pH+fU5BINqkaTzhFqtqu2FAKf4UqAUd5zAsnVoSO4llAm5pY6NahO0SqfMcEutWLYOBcP47zbvcYzj0iRHhw6fHRqxW35DjTjYo2j0sDc3kSXvlCOwswdNUbNonMeB1GABNbqwLmrXct0HqmhuxZ3TNX72KocnOTUWNlH1YQqR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855631; c=relaxed/simple;
	bh=aYdlUoW0DZp275ju7Ch+6Er/SQQSj0AIZNgqshillQo=;
	h=Date:To:From:Subject:Message-Id; b=sAHcPHu4PD8kAxE6zWP4FkMvv79BBz3R/hHLKR46nfKWmUcaBXmfPdAd9Yn2/FY/sktJxKjP2hk4+SxquX3BJXCb/y7UXBEIlY2IYXRF3/ZGq0M6v0TwtKweKRr2xXfu9iXJR4PWyTBy4JWDuruqfiXZzHUHG0/w3HmoMho6atE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=STW7fKT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="STW7fKT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8047C4CECF;
	Wed,  6 Nov 2024 01:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855630;
	bh=aYdlUoW0DZp275ju7Ch+6Er/SQQSj0AIZNgqshillQo=;
	h=Date:To:From:Subject:From;
	b=STW7fKT0Qm1cwC1GmoH7vkHOKtnSkJJjnTRENYGf3x1/KkNP2nidXvby6RrlEQuiz
	 7IEJ+XgVWWtJyo0BKkLhmU0cWPIF1Sd5G5Yk1ZHvSXo5wbYrFM1LuF0IPmpvBy+8xO
	 7FTaNZe69Ukbg7Rw6P71mmsGTjcsjpA4NVgJ/Ow8=
Date: Tue, 05 Nov 2024 17:13:50 -0800
To: mm-commits@vger.kernel.org,jesse.brandeburg@intel.com,horms@kernel.org,colin.i.king@gmail.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch removed from -mm tree
Message-Id: <20241106011350.C8047C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: add typo "exprienced" and "rewritting"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-typo-exprienced-and-rewritting.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: scripts/spelling.txt: add typo "exprienced" and "rewritting"
Date: Fri, 18 Oct 2024 10:47:19 +0800

Add typo "exprienced" and "rewritting".
They were found and fixed in follow patches:

Link: https://lore.kernel.org/all/90D42CB167CA0842+20241018021910.31359-1-wangyuli@uniontech.com/
Link: https://lore.kernel.org/all/45F06B5D4CA9F444+20241018023340.47617-1-wangyuli@uniontech.com/
Link: https://lkml.kernel.org/r/C1FE2459CF066CA5+20241018024719.58325-1-wangyuli@uniontech.com
Link: https://lore.kernel.org/all/20241017162846.GA51712@kernel.org/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Suggested-by: Simon Horman <horms@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-typo-exprienced-and-rewritting
+++ a/scripts/spelling.txt
@@ -674,6 +674,7 @@ explict||explicit
 explictely||explicitly
 explictly||explicitly
 expresion||expression
+exprienced||experienced
 exprimental||experimental
 extened||extended
 exteneded||extended
@@ -1388,6 +1389,7 @@ reuest||request
 reuqest||request
 reutnred||returned
 revsion||revision
+rewritting||rewriting
 rmeoved||removed
 rmeove||remove
 rmeoves||removes
_

Patches currently in -mm which might be from wangyuli@uniontech.com are


