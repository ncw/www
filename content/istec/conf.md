---
title: ISTEC 1008 Configuration software
description: ISTEC 1008 Configuration software
---


The ISTEC 1008 is configured using 1) a switch inside the ISTEC case, 2) a telephone attached to extension 21, and 3) via a serial port using a PC and the ISTEC program

  <dl>
    <dt>1). Configuration switch setting</dt>

    <dd>As a security measure, the ISDN protocol (EURO ISDN or 1TR6) is selected with a switch inside the equipment case.</dd>

    <dt>2). Configuration Telephone</dt>

    <dd>
      The telephone on the first extension (analogue interface a1/b1) has the extension number '21'. This telephone can be used to switch the systems' ISDN line configuration from 'Multiple Terminal Mode' to 'Telephone Exchange Mode'. The standard ISDN line setting is 'Multiple Terminal Mode'. For each individual extension the following luxury features are available to the attached telephone:

      <p>Call back Call transfer Call Rerouting Internal/External Internal conference call</p>

      <p>Pickup Broker Answering the Door Intercom Opening the door opener</p>
    </dd>

    <dt>3) Configuration with PC and ISTEC Program via serial RS232 port</dt>

    <dd>
      The program ISTEC.EXE allows access to the configuration settings at two levels of authorization:

      <dl>
        <dt>1) User Level</dt>

        <dd>
          The program starts up in the user level of authorization. At this level you can configure the following features:

          <dl>
            <dt>Display charges</dt>

            <dd>The charges incurred by each extension can be displayed. The price per unit and the currency can be changed.</dd>

            <dt>Print charges</dt>

            <dd>Print the charges incurred by all or just selected extensions.</dd>

            <dt>Clear charges</dt>

            <dd>Music on hold (on/off)</dd>

            <dt>Query Firmware version</dt>

            <dd>Determines the firmware version in the attached ISTEC system. Additionally, this selection also reads the number of S busses that the system supports and the number of available a/b analogue interfaces.</dd>
          </dl>
        </dd>

        <dt>2) Administration Level</dt>

        <dd>
          To enter the Administration level (which is password protected), select the 'Configuration' menu, then select 'Administration level' and enter the correct password, the system will then enter the Administration Level. At this level, you can configure all the remaining system characteristics and features:

          <dl>
            <dt>Protocol</dt>

            <dd>EURO ISDN or 1TR6</dd>

            <dt>ISDN Line mode</dt>

            <dd>Telephone Exchange or Multiple terminal</dd>

            <dt>Door intercom</dt>

            <dd>Assigns the door bell to a specific extension. The intercom may be answered from any extension.</dd>

            <dt>Creating TEI or MSN groups</dt>

            <dd>The incoming calls are signalled with their TEI (Terminal End Identifier) or MSN (Multiple Subscriber Number) and may be assigned to groups of extensions.</dd>

            <dt>Configure extensions.</dt>

            <dd>
              The following features can be configured for each individual extension:-

              <ul>
                <li>call authorization (internal only, answer only, Local,........)</li>

                <li>service identifier (e.g. telephone fax, modem...)</li>

                <li>call rerouting</li>

                <li>PIN (Personal Identification Number)</li>
              </ul>
            </dd>

            <dt>Reset to factory settings</dt>
          </dl>The ISTEC PC program can be used to prepare all the system settings prior to connecting the ISTEC system. The configuration can be saved on a diskette and then down-loaded from a PC on location.
        </dd>
      </dl>
    </dd>
  </dl>

  <h3>Call number plan</h3>

  <dl>
    <dt>Access Trunk line (PSTN)</dt>

    <dd>9 (UK version 0 for German version)</dd>

    <dt>Call pickup</dt>

    <dd>4</dd>

    <dt>Extension numbers</dt>

    <dd>21..28</dd>

    <dt>Activate call forwarding</dt>

    <dd>5xx (xx = extension number)</dd>

    <dt>Deactivate call forwarding</dt>

    <dd>5</dd>

    <dt>Activate external call forwarding</dt>

    <dd>6zzzzy (z = PIN, y = external number)</dd>

    <dt>Deactivate external call forwarding</dt>

    <dd>6</dd>

    <dt>Connect te door entry speaker</dt>

    <dd>7</dd>

    <dt>Release door LOCK</dt>

    <dd>....7 (While intercom is active)</dd>
  </dl>When using the point to point connection it is possible to program an 'operator extension'. Incoming calls will be transferred to extension 21-28 according to the DDI number.
