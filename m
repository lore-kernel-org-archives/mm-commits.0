Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D827493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VGOqkvCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5829C433C8;
	Mon, 11 Dec 2023 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257787;
	bh=0r9Zkn+EbrM79jrJtORyQ9d5FopJ8D65R+bBYAVIbu0=;
	h=Date:To:From:Subject:From;
	b=VGOqkvCGFD+klckeRvIKu9wI8sLpbdjPCJtHi7Uv4cm0wW+4lADpEdOeolrKtXWxG
	 tJSCoIVS2js8eZuyBIyCv99xdYjwlHpea9oaHd2JKgxsWopqTTFNPlbS9iDTIzV58n
	 y2xSav+j2hv6+N1gJ6PsgYVuuWjIOgPIZA7bz5w8=
Date: Sun, 10 Dec 2023 17:23:07 -0800
To: mm-commits@vger.kernel.org,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch removed from -mm tree
Message-Id: <20231211012307.A5829C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/spelling.txt: add more spellings to spelling.txt
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spellings-to-spellingtxt.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: scripts/spelling.txt: add more spellings to spelling.txt
Date: Wed, 22 Nov 2023 10:40:37 +0000

Some of the more common spelling mistakes and typos that I've found while
fixing up spelling mistakes in the kernel over the past couple of
releases.

Link: https://lkml.kernel.org/r/20231122104037.1770749-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spellings-to-spellingtxt
+++ a/scripts/spelling.txt
@@ -26,6 +26,7 @@ accelaration||acceleration
 accelearion||acceleration
 acceleratoin||acceleration
 accelleration||acceleration
+accelrometer||accelerometer
 accesing||accessing
 accesnt||accent
 accessable||accessible
@@ -137,6 +138,7 @@ anniversery||anniversary
 annoucement||announcement
 anomolies||anomalies
 anomoly||anomaly
+anonynous||anonymous
 anway||anyway
 aplication||application
 appearence||appearance
@@ -267,6 +269,7 @@ cadidate||candidate
 cahces||caches
 calender||calendar
 calescing||coalescing
+calibraiton||calibration
 calle||called
 callibration||calibration
 callled||called
@@ -288,6 +291,7 @@ capabitilies||capabilities
 capablity||capability
 capatibilities||capabilities
 capapbilities||capabilities
+captuer||capture
 caputure||capture
 carefuly||carefully
 cariage||carriage
@@ -340,6 +344,7 @@ comminucation||communication
 commited||committed
 commiting||committing
 committ||commit
+commmand||command
 commnunication||communication
 commoditiy||commodity
 comsume||consume
@@ -406,6 +411,7 @@ continious||continuous
 continous||continuous
 continously||continuously
 continueing||continuing
+contiuous||continuous
 contraints||constraints
 contruct||construct
 contol||control
@@ -757,6 +763,7 @@ hardward||hardware
 havind||having
 heirarchically||hierarchically
 heirarchy||hierarchy
+heirachy||hierarchy
 helpfull||helpful
 hearbeat||heartbeat
 heterogenous||heterogeneous
@@ -1199,6 +1206,7 @@ priting||printing
 privilaged||privileged
 privilage||privilege
 priviledge||privilege
+priviledged||privileged
 priviledges||privileges
 privleges||privileges
 probaly||probably
@@ -1251,6 +1259,7 @@ purgable||purgeable
 pwoer||power
 queing||queuing
 quering||querying
+querrying||querying
 queus||queues
 randomally||randomly
 raoming||roaming
@@ -1324,6 +1333,7 @@ reseting||resetting
 reseved||reserved
 reseverd||reserved
 resizeable||resizable
+resonable||reasonable
 resotre||restore
 resouce||resource
 resouces||resources
@@ -1427,6 +1437,7 @@ sliped||slipped
 softwade||software
 softwares||software
 soley||solely
+soluation||solution
 souce||source
 speach||speech
 specfic||specific
@@ -1458,6 +1469,7 @@ standart||standard
 standy||standby
 stardard||standard
 staticly||statically
+statisitcs||statistics
 statuss||status
 stoped||stopped
 stoping||stopping
@@ -1548,6 +1560,7 @@ threds||threads
 threee||three
 threshhold||threshold
 thresold||threshold
+throtting||throttling
 throught||through
 tansition||transition
 trackling||tracking
@@ -1571,6 +1584,7 @@ tranasction||transaction
 tranceiver||transceiver
 tranfer||transfer
 tranmission||transmission
+tranport||transport
 transcevier||transceiver
 transciever||transceiver
 transferd||transferred
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


