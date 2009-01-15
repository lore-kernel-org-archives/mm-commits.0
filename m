From: akpm@linux-foundation.org
Subject: + serial-add-supraexpress-336i-pnp-voice-modem.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:25:09 -0800
Message-ID: <200901152325.n0FNP9m7027798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777AbZAOXZs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:25:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.gagnon@yahoo.com, alan@lxorguk.ukuu.org.uk


The patch titled
     serial: add SupraExpress 336i PnP Voice Modem
has been added to the -mm tree.  Its filename is
     serial-add-supraexpress-336i-pnp-voice-modem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial: add SupraExpress 336i PnP Voice Modem
From: Daniel Gagnon <daniel.gagnon@yahoo.com>

Add SupraExpress 336i PnP Voice Modem

Tested and working with the following device: (output from lspnp -v)
01:01.00 SUP1381 (unknown)
    state = active
        io 0x2f8-0x2ff
        irq 3

Signed-off-by: Daniel Gagnon <daniel.gagnon <at> yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/serial/8250_pnp.c~serial-add-supraexpress-336i-pnp-voice-modem drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-add-supraexpress-336i-pnp-voice-modem
+++ a/drivers/serial/8250_pnp.c
@@ -270,6 +270,8 @@ static const struct pnp_device_id pnp_de
 	{       "RSS0250",              0       },
 	/* SupraExpress 28.8 Data/Fax PnP modem */
 	{	"SUP1310",		0	},
+ 	/* SupraExpress 336i PnP Voice Modem */
+ 	{       "SUP1381",              0       },
 	/* SupraExpress 33.6 Data/Fax PnP modem */
 	{	"SUP1421",		0	},
 	/* SupraExpress 33.6 Data/Fax PnP modem */
_

Patches currently in -mm which might be from daniel.gagnon@yahoo.com are

serial-add-supraexpress-336i-pnp-voice-modem.patch

